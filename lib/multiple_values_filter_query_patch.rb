require 'pp'

module MultipleValuesFilterQueryPatch
  def self.included(base)
    base.extend(ClassMethods)
    #base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      #if self.operators_by_filter_type
      #  self.operators_by_filter_type[:integer_list] = [ "=" ]
      #end
      alias_method_chain :add_filter_error, :multiple_issues
      #alias_method_chain :add_custom_field_filter, :multiple_issues
      #alias_method_chain :available_filters, :multiple_issues
      alias_method_chain :sql_for_field, :multiple_issues
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    #def statement
    #end
    
    #def validate_query_filters_with_multiple_issues
    #  filters.each_key do |field|
    #    if values_for(field)
    #      case type_for(field)
    #      when :integer
    #        add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/^[+-]?\d+$/) }
    #      when :float
    #        add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/^[+-]?\d+(\.\d*)?$/) }
    #      when :date, :date_past
    #        case operator_for(field)
    #        when "=", ">=", "<=", "><"
    #          add_filter_error(field, :invalid) if values_for(field).detect {|v|
    #            v.present? && (!v.match(/\A\d{4}-\d{2}-\d{2}(T\d{2}((:)?\d{2}){0,2}(Z|\d{2}:?\d{2})?)?\z/) || parse_date(v).nil?)
    #          }
    #        when ">t-", "<t-", "t-", ">t+", "<t+", "t+", "><t+", "><t-"
    #          add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/^\d+$/) }
    #        end
    #      end
    #    end

    #    add_filter_error(field, :blank) unless
    #    # filter requires one or more values
    #    (values_for(field) and !values_for(field).first.blank?) or
    #      # filter doesn't require any value
    #      ["o", "c", "!*", "*", "t", "ld", "w", "lw", "l2w", "m", "lm", "y"].include? operator_for(field)
    #  end if filters
    #end

    def add_filter_error_with_multiple_issues(field, message)
      if type_for(field) == :integer
        # do custom validation here
      else
        add_custom_field_filter_without_multiple_issues(field, message)
      end
    end

    #def add_custom_field_filter_with_multiple_issues(field, assoc=nil)
    #  p 'adddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd'
    #  p field
    #  puts

    #  #options = field.format.query_filter_options(field, self)
    #  #p options
    #  #if field.format.target_class && field.format.target_class <= User
    #  #  if options[:values].is_a?(Array) && User.current.logged?
    #  #    options[:values].unshift ["<< #{l(:label_me)} >>", "me"]
    #  #  end 
    #  #end 

    #  #filter_id = "cf_#{field.id}"
    #  #filter_name = field.name
    #  #if assoc.present?
    #  #  filter_id = "#{assoc}.#{filter_id}"
    #  #  filter_name = l("label_attribute_of_#{assoc}", :name => filter_name)
    #  #end 
    #  #add_available_filter filter_id, options.merge({
    #  #  :name => filter_name,
    #  #  :field => field
    #  #})
    #  
    #  _options = field.format.query_filter_options(field, self)
    #  puts
    #  puts "options: #{_options.inspect}"
    #  puts
    #  if _options[:type] == :integer
    #    filter_id = "cf_#{field.id}_in"
    #    filter_name = "#{field.name}_in"
    #    add_available_filter filter_id, _options.merge({
    #      :type => :integer_list,
    #      :name => filter_name,
    #      :field => field
    #    })
    #  end

    #  add_custom_field_filter_without_multiple_issues(field, assoc=nil)
    #end

    #def available_filters_with_multiple_issues
    #  filters = available_filters_without_multiple_issues
    #  return filters
    #end

    def sql_for_field_with_multiple_issues(field, operator, value, db_table, db_field, is_custom_filter=false)
      sql = ''
      if type_for(field) == :integer and is_custom_filter
        values = value.first.split(',').map{|s| s.to_i}
        sql = "(#{db_table}.#{db_field} <> '' AND CAST(CASE #{db_table}.#{db_field} WHEN '' THEN '0' ELSE #{db_table}.#{db_field} END AS decimal(30,3)) IN (#{values.join(',')}))"
      else
        sql = sql_for_field_without_multiple_issues(field, operator, value, db_table, db_field, is_custom_filter)
      end
      return sql
    end
  end
end
