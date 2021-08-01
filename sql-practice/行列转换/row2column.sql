select
    t0.id
    ,t1.subject
    ,case when t1.subject = 'chinese' then t0.chinese
        when t1.subject = 'math' then t0.math
        when t1.subject = 'english' then t0.english
    end as score
from `row` t0 join (
    select 
        id
        ,t.subject 
    from `row` 
    lateral view explode(array('chinese', 'math', 'english')) t AS subject
) t1 on t0.id = t1.id;