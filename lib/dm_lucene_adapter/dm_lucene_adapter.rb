require 'dm_lucene_adapter/typed_abstract_adapter'
require 'java'
include_class "de.saumya.lucene.LuceneService"

module DataMapper
  module Adapters
    class LuceneAdapter < TypedAbstractAdapter
      
      def initialize(*args)
        options = args[1]
        @service = LuceneService.new(java.io.File.new(options[:index] || "index"))
        super
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
        indexer = @service.create_indexer
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
      def do_read(query)
#        p query
        reader = @service.create_reader
        if(query.conditions.nil?)
          result = []
          reader.read_all.each do |resource|
            map = {}
            resource.each do |k,v|
              map[k] = v
            end
            result << map
          end
          result
        else
          ops = query.conditions.operands
          if(ops.size == 1 && ops[0].class == DataMapper::Query::Conditions::EqualToComparison && ops[0].subject.name == :id)
            map = {}
            reader.read(query.conditions.operands[0].value).each do |k,v|
              map[k] = v
            end
            [map]
          else
            []
          end
        end
      ensure
        reader.close if reader
      end    

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
        deleter = @service.create_deleter
        resources = read(collection.query)
        resources.each do |resource|
          deleter.delete(resource.id)
        end
        deleter.close
        deleter = nil
        indexer = @service.create_indexer
        attributes = attributes_as_fields(attributes)
        resources.each do |resource|
          resource.update(attributes)
          map = {}
          resource.each { |k,v| map[k.to_s] = v.to_s}
          indexer.index(map)
        end
        count
      ensure
        indexer.close if indexer rescue nil
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
        indexer = @service.create_deleter
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
