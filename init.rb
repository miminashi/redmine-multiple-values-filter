Redmine::Plugin.register :multiple_values_filter do
  name 'Multiple values for filter plugin'
  author 'miminashi'
  description 'This plugin allows more than one values for a query parameter'
  version '0.0.1'
  url 'https://github.com/miminashi/redmine-multiple-values-filter'
  author_url 'https://github.com/miminashi/redmine-multiple-values-filter'
end

require 'multiple_values_filter_query_patch'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'issue_query'
  unless IssueQuery.included_modules.include?(MultipleValuesFilterQueryPatch)
    IssueQuery.send(:include, MultipleValuesFilterQueryPatch)
  end
end
