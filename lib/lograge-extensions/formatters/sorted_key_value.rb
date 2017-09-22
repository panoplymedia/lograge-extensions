# Custom lograge formatter to re-order fields
module LogrageExtensions
  module Formatters
    class SortedKeyValue
      def call(data)
        fields = fields_to_display(data)

        event = fields.map { |key| format(key, data[key]) }
        
        # Show location on redirects
        event << format(:location, data[:location]) if data[:location]
        
        event.join(' ')
      end

      def fields_to_display(data)
        # Order keys to preference
        fields = [:status, :method, :path, :format, :controller, :action, :duration, :view, :db]
        
        # Check for macthing keys else default behaviour
        if fields.sort != (data.keys.sort - [:location]) # Location only on redirects
          return data.keys
        else
          return fields
        end
      end

      def format(key, value)
        if key == :error
          # Exactly preserve the previous output
          # Parsing this can be ambigious if the error messages contains
          # a single quote
          value = "'#{value}'"
        else
          # Ensure that we always have exactly two decimals
          value = Kernel.format('%.2f', value) if value.is_a? Float
        end

        "#{key}=#{value}"
      end
    end
  end
end