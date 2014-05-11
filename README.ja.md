Redmine multiple values for query filter plugin
===============

Redmineのクエリパラメータに複数の値を指定できるようにします.

## クエリの例

### cf_3の値が1と2のissuesを取得する

* cf_3 はidが3のカスタムフィールド

[http://localhost:3000/projects/hoge/issues.json?cf_3=1,2](http://localhost:3000/projects/hoge/issues.json?cf_3=1,2)
