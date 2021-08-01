with
a as
(
    select
        *,row_number() over (order by cishu desc) as paiming
    from fangwen
     )
select b.leibie,avg(cishu)
from
    (
        select *
        from a
        where
                paiming > (select max(paiming) from a ) * 0.2

        )b
group by leibie
