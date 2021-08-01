select
    user_id
from (
    select
        t0.user_id as user_id
        ,t0.event_day as event_day
        ,t1.rank_day - t0.rank as diff
    from (
        select -- 首先根据用户和日期进行去重作为基础数据
            user_id
            ,event_day
            ,row_number() over(partition by user_id order by user_id, event_day rows between unbounded preceding and unbounded following) as rank
        from
            user_behavior u
        where
            event_day <= d and event_day >= d - 7 + 1
        group by
            user_id, event_day
    ) t0
    left join (
        select -- 将日期转换为有序数字，解决跨月，跨年引起的计算误差
            event_day
            ,row_number() as rank_day
        from
            user_behavior u
        where
            event_day <= d and event_day >= d - 7 + 1
        group by
            event_day
        order by 
            event_day
    ) t1
    on
        t0.event_day = t1.event_day
) tmp
group by
    event_day, user_id, diff
having
    count(*) = 7 -- 连续 7 天登录，同理可以计算其它逻辑