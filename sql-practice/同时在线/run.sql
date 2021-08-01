select
    max(online_cnt) as result
from (
    select
        tmp.id
        ,tmp.op_time
        ,tmp.online_state
        -- 对全部数据开窗，按照 op_time 排序，如果没有指定窗口大小，则默认从第一行到当前行
        ,sum(online_state) over(order by op_time) as online_cnt
    from (
        select id, stt as op_time, 1 as online_state
        from login_log
        union
        select id, edt as op_time, -1 as online_state
        from login_log
    ) tmp
    order by op_time
) res