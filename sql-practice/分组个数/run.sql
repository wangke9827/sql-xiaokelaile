select
    uidss
    ,count(*) as cnt
from (
    select
        rn
        ,collect_list(uids) as uidss
    from (
        select
            uids
            ,rn
        from (
            select
                uid1
                ,uid2
                ,row_number() over() as rn
            from test1
        ) tmp lateral view explode(array(uid1, uid2)) t as uids
        order by uids, rn
    ) t2
    group by rn
) t3
group by uidss;