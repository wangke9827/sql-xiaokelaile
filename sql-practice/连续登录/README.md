# 连续登录

连续登录类的题经常出现在数据岗的面试中，题目一般很短，比如：10 亿用户量，日均活跃用户 1 亿，请找出 7 天连续登陆的用户。

核心思路是，如果 (login_date - row_number(login_date)) 值是相等的，那么 login_date 就是连续的，根据这个即可判断是否连续登录，需要注意的边界条件是年和月的边界。

## 如何在面试中清晰、快速的写出来

