module DataMapper
  module Adapters
    class LuceneAdapter < AbstractAdapter

      private
      def index_directory(model)
        @path / "#{model.storage_name(name)}"
      end

      def lucene(model)
        LuceneService.new(java.io.File.new(index_directory(model).to_s))
      end

      public

      def initialize(name, options = {})
        super
        (@path = Pathname(@options[:path]).freeze).mkpath
      end

      # @param [Enumerable<Resource>] resources
      #   The list of resources (model instances) to create
      #
      # @return [Integer]
      #   The number of records that were actually saved into the data-store
      #
      # @api semipublic
      def create(resources)
        count = 0
        indexer = lucene(resources.first.model).create_indexer
        resources.each do |resource|
          resource.id = indexer.next_id
          map = {}
          resource.attributes.each { |k,v| map[k.to_s] = v.to_s}
          indexer.index(map)
          count += 1
        end
        count
      ensure
        indexer.close if indexer
      end

      # @param [Query] query
      #   the query to match resources in the datastore
      #
      # @return [Enumerable<Hash>]
      #   an array of hashes to become resources
      #
      # @api semipublic
      def read(query)
        is_sorting = query.order.size > 1 || query.order[0].target.name != :id || query.order[0].operator != :asc
        offset, limit = is_sorting ? [0, -1] : [query.offset, query.limit || -1]

        resources = do_read(offset, limit, query)
        resources.each do |resource|
          query.fields.each do |field| 
            attribute = field.name.to_s
            resource[attribute] = field.typecast(resource[attribute])
          end
        end
        
        if is_sorting
          #records = records.uniq if unique?
          resources = query.sort_records(resources)
          resources = query.limit_records(resources)
        end
        resources
      end

      private

      def do_read(offset, limit, query)
        reader = lucene(query.model).create_reader
        if(query.conditions.nil?)
          result = []

#p query
# TODO set limit, offset to default of sorting is non default
          reader.read_all(offset, limit).each do |resource|
            map = {}
            resource.each do |k,v|
              map[k] = v
            end
            result << map
          end
          result
        else
          ops = query.conditions.operands
          if(ops.size == 1 && ops.first == :eql && ops.first.subject.name == :id)
            map = {}
            reader.read(query.conditions.operands.first.value).each do |k,v|
              map[k] = v
            end
            [map]
          else
            op = query.conditions.slug.to_s.upcase
            lquery = make_query("", ops, op)
            lquery.sub!(/#{op} $/, '') 
            result = []
            reader.read_all(offset, limit, lquery).each do |resource|
              map = {}
              resource.each do |k,v|
                map[k] = v
              end
              result << map
            end
            result
          end
        end
      ensure
        reader.close if reader
      end    

      private

      def make_query(lquery, ops, operator)
        ops.each do |comp|
          case comp.slug
          when :like
            comp.value.split(/\s/).each do |value|
              lquery += "#{comp.subject.name.to_s}:#{value}"
              unless comp.value =~ /%|_|\?|\*/
                lquery += "~"
              end
              lquery += " #{operator} "
            end
          when :eql
            lquery += "#{comp.subject.name.to_s}:\"#{comp.value}\" #{operator} "
          when :not
            if lquery.size == 0
              lquery = "NOT "
            else
              lquery.sub!(/#{operator}/, "NOT")
            end
            lquery = make_query(lquery, comp.operands, operator)
          else
            warn "ignore unsupported operand #{comp.slug}"
          end
        end
        lquery
      end

      public

      # @param [Hash(Property => Object)] attributes
      #   hash of attribute values to set, keyed by Property
      # @param [Collection] collection
      #   collection of records to be updated
      #
      # @return [Integer]
      #   the number of records updated
      #
      # @api semipublic
      def update(attributes, collection)
        count = 0
        service = lucene(collection.model)
        deleter = service.create_deleter
        resources = read(collection.query)
        resources.each do |resource|
          deleter.delete(resource["id"])
        end
        deleter.close
        deleter = nil
        indexer = service.create_indexer
        attributes = attributes_as_fields(attributes)
        resources.each do |resource|
          resource.update(attributes)
          map = {}
          resource.each { |k,v| map[k.to_s] = v.to_s}
          indexer.index(map)
        end
        count
      ensure
        indexer.close if indexer
        deleter.close if deleter
      end

      # @param [Collection] collection
      #   collection of records to be deleted
      #
      # @return [Integer]
      #   the number of records deleted
      #
      # @api semipublic
      def delete(collection)
        count = 0
        indexer = lucene(collection.model).create_deleter
        collection.each do |resource|
          indexer.delete(resource.id)
          count += 1
        end
        count
      ensure
        indexer.close if indexer
      end
    end
  end
end
