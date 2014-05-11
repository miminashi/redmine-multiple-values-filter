Redmine multiple values filter plugin
===============

This plugin allows querying with multiple values for a field.

## Example Query

### Retrieve issues with cf_3=1 and cf_3=2

* cf_3 is a custom field that id is 3

[http://localhost:3000/projects/hoge/issues.json?cf_3=1,2](http://localhost:3000/projects/hoge/issues.json?cf_3=1,2)

