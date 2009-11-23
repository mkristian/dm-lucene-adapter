require 'dm-core/adapters/abstract_adapter'
module DataMapper
  module Adapters
    class TypedAbstractAdapter < AbstractAdapter
      
      def do_read(query)
        raise NotImplementedError, "#{self.class}#do_read not implemented"
      end

      def read(query)
        result = do_read(query)
        types  = query.fields.map { |property| property.primitive }
        result.each do |resource|
          i = 0
          resource.each do |k,v|
            case types[i].to_s
            when "Integer"
              resource[k] = v.to_i
            when "Float"
              resource[k] = v.to_f
            when "TrueClass"
              resource[k] = v == "true"
#TODO BigDecimal, Date, DateTime, Time
            end
            i += 1
          end
        end
        result
      end
    end
  end
end
