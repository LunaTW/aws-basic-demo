# aws-basic-demo

## Practice
- 创建cloudwatch event rule每分钟自动触发Lambda（Lambda功能需要自己实现，向cloudwatch metrics里push自定义的metrics），设置alarm检测task中定义的metric，自定义并监控条件使alarm触发阈值，alarm触发SNS，SNS发告警到邮箱。
- 创建cloudwatch event rules，每分钟自动触发Lambda（输出固定格式的log message）。为lambda log创建metric filter，匹配log message，创建新的metric，自定义并监控条件使alarm触发阈值，alarm出发SNS，SNS发告警到邮箱。

Task：
七星彩彩票推荐系统
1. 七星彩规则 [0-10]*6 + [0-14]*1
2. cloudwatch event 每五分钟 触发一次 彩票自动生成器（auto_lottery_generator_lambda）， 其生成的结果将发布至 彩票推荐SNS（luna_lottery_recommendation_topic），下游的订阅者SQS（luna_lottery_recommendation_queue）将会得到此推荐号码。(Task 1)
3. 作为VIP 用户，彩票推荐服务将通过Email的形式推送给我 （SQS -> email）(Task 2)