# aws-lambda-demo


## Baisc
#### What is serverless?

无服务器计算（或简称 serverless），是一种执行模型，在该模型中，云服务商（AWS，Azure 或 Google Cloud）负责通过动态分配资源来执行一段代码，并且仅收取运行代码所使用资源的费用。
该代码通常运行在无状态的容器中，能够被包括 HTTP 请求、数据库事件、队列服务、监控报警、文件上传、调度事件（cron 任务）等各种事件触发。
被发送到云服务商执行的代码通常是以函数的形式，因此，无服务器计算有时是指 “函数即服务” 或者 FAAS。
以下是主要云服务商提供的 FAAS 产品：
- AWS: AWS Lambda
- Microsoft Azure: Azure Functions
- Google Cloud: Cloud Functions

PS: 不依赖特定终端, 不关注业务代码以外的东西

#### Create lambda function with AWS Web Console and test

[This is a Hello-World example](https://aws.amazon.com/cn/getting-started/hands-on/run-serverless-code/)

#### Lambda function via aws cli with ZIP file and invoke Create lambda
[e.g. 将 AWS Lambda 与 AWS Command Line Interface 结合使用](https://docs.aws.amazon.com/zh_cn/lambda/latest/dg/gettingstarted-awscli.html)

1. 创建执行角色 (create-role)
    ```
    aws iam create-role --role-name your-name --assume-role-policy-document file://./policy_setting/trust-policy.json --profile xx(saml2aws name)
    注意⚠️： file:// 不可省略 🙅
   ```

2. 要向角色添加权限 (attach-policy-to-role)
    ```
   # 添加 AWSLambdaBasicExecutionRole 托管策略, 该策略具有函数将日志写入 CloudWatch Logs 所需的权限。
   aws iam attach-role-policy --role-name your-name --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
   ```
3. Prepare zip file
    ```
   zip function.zip index.js
   ```
4. 创建 Lambda 函数 (create-function)
    ```
   # 将角色 ARN 中123456789012替换为您的账户 ID
   aws lambda create-function --function-name my-function \
   --zip-file fileb://function.zip --handler index.handler --runtime nodejs12.x \
   --role arn:aws:iam::123456789012:role/lambda-ex
   ```

5. Create lambda by aws cloudformation
    ``` 
    https://leaherb.com/aws-lambda-tutorial-101/
   ```

6. Log lambda request event to cloudwatch
    ```
   aws lambda invoke \
   --invocation-type RequestResponse \
   --function-name LunaHelloLambdaFunction \
   --log-type Tail outputfile.txt;  more outputfile.txt
   ```

### Advance
1. Cloudwatch events trigger lambda regularly
    ```
   https://docs.aws.amazon.com/zh_cn/AmazonCloudWatch/latest/events/RunLambdaSchedule.html
   ```

2. Copy file from a s3 bucket to another s3 bucket
    ```
   https://aws.amazon.com/cn/premiumsupport/knowledge-center/move-objects-s3-bucket/
   https://docs.aws.amazon.com/zh_cn/AmazonS3/latest/userguide/creating-bucket.html
   
   s s3 sync s3://luna-console-1 s3://luna-console-2
   ```

3. Trigger Cloudwatch alarm when Lambda failed.





## Ref
- [AWS Lambda](https://aws.amazon.com/cn/lambda/)
- [有状态与无状态 Container](https://www.redhat.com/zh/topics/cloud-native-apps/stateful-vs-stateless)
- [什么是无服务器?](https://serverless-stack.com/chapters/zh/what-is-serverless.html)
- [What is AWS Lambda?](https://serverless-stack.com/chapters/what-is-aws-lambda.html)

