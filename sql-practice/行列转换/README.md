# README

## 数据准备

```sql
create table `row` (id int, chinese int, math int, english int);

insert into `row` values
    (1001, 70, 40, 80),
    (1002, 30, 70, 60);
```

```sql
create table `column` (id int, subject string, score int);

insert into `column` values
    (1001, 'chinese', 70),
    (1001, 'math', 40),
    (1001, 'english', 80),
    (1002, 'chinese', 30),
    (1002, 'math', 70),
    (1002, 'english', 60);
```

## 行转列

利用 `lateral view` 和 UDTF 函数 `explode` 将行转为列：

```sql
select 
    id
    ,t.subject 
from `row` 
lateral view explode(array('chinese', 'math', 'english')) t AS subject;

+-------+------------+
|  id   | t.subject  |
+-------+------------+
| 1001  | chinese    |
| 1001  | math       |
| 1001  | english    |
| 1002  | chinese    |
| 1002  | math       |
| 1002  | english    |
+-------+------------+
```

然后用 id 将该表与原表关联，最后用 `case when` 将特定的数据取出来即可：

```sql
select *
from `row` t0 join (
    select 
        id
        ,t.subject 
    from `row` 
    lateral view explode(array('chinese', 'math', 'english')) t AS subject
) t1 on t0.id = t1.id;

+--------+-------------+----------+-------------+--------+-------------+
| t0.id  | t0.chinese  | t0.math  | t0.english  | t1.id  | t1.subject  |
+--------+-------------+----------+-------------+--------+-------------+
| 1001   | 70          | 40       | 80          | 1001   | chinese     |
| 1001   | 70          | 40       | 80          | 1001   | math        |
| 1001   | 70          | 40       | 80          | 1001   | english     |
| 1002   | 30          | 70       | 60          | 1002   | chinese     |
| 1002   | 30          | 70       | 60          | 1002   | math        |
| 1002   | 30          | 70       | 60          | 1002   | english     |
+--------+-------------+----------+-------------+--------+-------------+
```

## 列转行

先增加列，然后利用 `if` 或者 `case when` 将特定的组合比如：(id subject) 对应的 socre 置入特定的位置：

```sql
select
    id
    ,if(subject = 'chinese', score, 0) as chinese
    ,if(subject = 'math', score, 0) as math
    ,if(subject = 'english', score, 0) as english
from `colume`

+-------+----------+-------+----------+
|  id   | chinese  | math  | english  |
+-------+----------+-------+----------+
| 1001  | 70       | 0     | 0        |
| 1001  | 0        | 40    | 0        |
| 1001  | 0        | 0     | 80       |
| 1002  | 30       | 0     | 0        |
| 1002  | 0        | 70    | 0        |
| 1002  | 0        | 0     | 60       |
+-------+----------+-------+----------+
```

最后利用分组 `group by` 和聚合函数 `max` 取出正确的值即可。