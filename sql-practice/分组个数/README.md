# 分组个数

如下表：

|uid1|uid2|
|----|----|
|a|b|
|b|a|
|a|c|
|c|d|
|e|f|

统计结果如下所示：

|uids|cnt|
|----|---|
|["a","b"]|2|
|["a","c"]|1|
|["c","d"]|1|
|["e","f"]|1|

## 数据准备

```sql
create table test1 (uid1 string, uid2 string);

insert into test1 values 
    ('a', 'b'),
    ('b', 'a'),
    ('a', 'c'),
    ('c', 'd'),
    ('e', 'f');
```

## 思路

由于 a-b 和 b-a 需要被统计为同一组，这里的思路是行转列之后排序，然后再列转行还原，最后统计即可。