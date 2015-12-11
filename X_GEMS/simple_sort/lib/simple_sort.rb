require "simple_sort/version"

module SimpleSort
  class Engine < Rails::Engine; end

  module Base
    extend ActiveSupport::Concern

    class_methods do
      def ss_available_fields_filter fields
        available_fields = self.columns.map(&:name)

        fields.inject([]) do |ary, field|
          ary.push(field) if available_fields.include?(field.to_s)
          ary
        end
      end

      def ss_table_field_order_sql fields
        fields.map{ |field| "#{ table_name }.#{ field }" }.join(', ')
      end
    end

    included do
      scope :mysql_random, ->{ reorder('RAND()')   }
      scope :psql_random,  ->{ reorder('RANDOM()') }

      scope :max2min, ->(fields = [:id]) {
        fields  = Array.wrap fields
        return nil if fields.blank?

        fields  = ss_available_fields_filter( fields )
        sql_str = ss_table_field_order_sql( fields )

        reorder("#{ sql_str } DESC")
      }

      scope :min2max, ->(fields = [:id]) {
        fields  = Array.wrap fields
        return nil if fields.blank?

        fields  = ss_available_fields_filter( fields )
        sql_str = ss_table_field_order_sql( fields )

        reorder("#{ sql_str } ASC")
      }

      scope :simple_sort, ->(params, default_sort_field = nil){
        sort_column = params[:sort_column]
        sort_type   = params[:sort_type]

        return max2min(default_sort_field) unless sort_column
        return max2min(sort_column)        unless sort_type

        sort_type.downcase == 'asc' ? max2min(sort_column) : min2max(sort_column)
      }
    end
  end
end
