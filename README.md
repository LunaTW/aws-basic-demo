# aws-basic-demo

## Task：
七星彩彩票推荐系统
1. 七星彩规则 [0-10]*6 + [0-14]*1
2. cloudwatch event 每五分钟 触发一次 彩票自动生成器（auto_lottery_generator_lambda）， 其生成的结果将发布至 彩票推荐SNS（luna_lottery_recommendation_topic），下游的订阅者SQS（luna_lottery_recommendation_queue）将会得到此推荐号码。(Task 1)
3. 作为VIP 用户，彩票推荐服务将通过Email的形式推送给我 （SNS -> email）(Task 2)
4. 作为普通客户，彩票推荐服务将通过Email的形式推送给我（SQS可订阅多个客户感兴趣的SNS topic，然后 SQS -> lambda -> email）(Task3) 

监控系统
0. KMS 加密
1. 彩票推荐系统通过 SNS （luna_monitoring_SNS）收集各项监控数据，并将收集的数据发送给 监控系统中（admin email）.
2. VIP监控平台：经大师计算，13 不是一个吉利的彩票数字，因此，决定添加一个监控，即 当 vip推荐号码 中出现数字13时，则会生成警报。将会发送将报警信息发送至 彩票监控平台（luna_monitoring_SNS）。(SNS(lottery_generator) --> lambda -> dlq -> metric -> SNS(monitoring) -> email)（task 4）
3. VIP监控Plus：增加一个 彩票自动生成器（auto_lottery_generator_lambda）的监控，来监控是否出出现问题13。（custom metric）（Task 5）

数据持久化
1. 增加 DynamoDB 数据库，保存所有数据记录 （Task6）


## Ref
- [Amazon CloudWatch 常见问题](https://aws.amazon.com/cn/cloudwatch/faqs/)
- [Amazon CloudWatch Concepts](https://docs.aws.amazon.com/zh_cn/AmazonCloudWatch/latest/monitoring/cloudwatch_concepts.html)
- [什么是 Amazon CloudWatch Events？](https://docs.amazonaws.cn/AmazonCloudWatch/latest/events/WhatIsCloudWatchEvents.html)
- [The most minimal AWS Lambda + Python + Terraform setup](https://www.davidbegin.com/the-most-minimal-aws-lambda-function-with-python-terraform/)
- [aws_sns_topic_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)
- [boto3.amazonaws](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html#SNS.Client.publish)
- [使用 AWS Lambda 环境变量](https://docs.aws.amazon.com/zh_cn/lambda/latest/dg/configuration-envvars.html#configuration-envvars-config)
- [CloudWatch Metrics 的相關概念](https://rickhw.github.io/2017/03/02/AWS/Study-Notes-CloudWatch-Metrics/)
- [为什么我的 CloudWatch 警报会在没有任何数据点超出阈值时触发？](https://aws.amazon.com/cn/premiumsupport/knowledge-center/cloudwatch-trigger-metric/)
- [sns-email-subscription module](https://registry.terraform.io/modules/QuiNovas/sns-email-subscription/aws/latest?tab=inputs)
- [Github: tf-sns-email-list](https://github.com/zghafari/tf-sns-email-list)
- [aws lambda之接收sns消息](https://blog.csdn.net/Jailman/article/details/102728219)
- [使用node.js发布到Amazon sns主题的参数示例](https://www.coder.work/article/7232808)
- [Calling the setSMSAttributes operation](http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/SNS.html#publish-property)
- [publish-sns-message-for-lambda-function](https://stackoverflow.com/questions/34029251/aws-publish-sns-message-for-lambda-function-via-boto3-python2)
- [为什么在 CloudWatch 警报触发时，我没有收到 SNS 通知](https://aws.amazon.com/cn/premiumsupport/knowledge-center/cloudwatch-receive-sns-for-alarm-trigger/)
- [sns不同主题订阅](https://advancedweb.hu/how-to-target-subscribers-in-an-sns-topic/)
- [Send an email using the AWS SDK for Python (Boto)](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-using-sdk-python.html)
- [sqs-microservice-python3](https://github.com/Keetmalin/AWS-SQS-SES-Lambda-Thread-Polling/blob/master/sqs-microservice-python3.py)
- [Lambda-AWS-SES-Send-Email Public](https://github.com/thigley986/Lambda-AWS-SES-Send-Email/blob/master/SendEmail.py)
- [为什么lambda send email 失败？](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/request-production-access.html?icmpid=docs_ses_console)

