# Liepin Job website scraper
# 猎聘网 - 招聘数据挖掘（爬虫软件）

## Usage
change the following key and city code you want. If you want to know more city code,
just message me, I maybe of help.
## 使用说明
更改主Ruby文件夹里所需要搜索的内容，以及你所关心的城市， 如果把城市去掉则结果应该是全国内的所有搜索结果。
参数更改完成之后，在命令行里运行 `ruby liebao.rb` 即可。注意运行时命令行必须指向文件所在文件夹。
等待几分钟及数十分钟不等即可得到所需的结果。

所的结果主要包括：标题，公司，公司概况，工作地点，薪水。

## Code need to change

```ruby
# liebao.rb
results = page.form do |search|
  search.key = '前端' # Change the keywords you want to search
  search.dqs = '010' # City code, 010 for Beijing, 020 for Shanghai
end.submit
```

```
ruby liebao.rb
```
