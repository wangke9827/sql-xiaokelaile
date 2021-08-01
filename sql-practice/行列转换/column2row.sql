select
    id
    ,max(if(subject = 'chinese', score, 0)) as chinese
    ,max(if(subject = 'math', score, 0)) as math
    ,max(if(subject = 'english', score, 0)) as english
from `column`
group by id