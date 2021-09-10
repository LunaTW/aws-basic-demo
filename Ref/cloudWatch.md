## Baisc

CloudWatch 是什么？
```
Amazon CloudWatch 是一项针对 AWS 云资源和在 AWS 上运行的应用程序的监控服务。
使用 Amazon CloudWatch 可以收集和跟踪指标、收集和监控日志文件以及设置警报。

Amazon CloudWatch 可以监控各种 AWS 资源，例如 Amazon EC2 实例、Amazon DynamoDB 表、Amazon RDS 数据库实例、应用程序和服务生成的自定义指标以及应用程序生成的所有日志文件。
您可通过使用 Amazon CloudWatch 全面地了解系统的资源使用率、应用程序性能和运行状况。使用这些分析结果，您可以及时做出反应，保证应用程序顺畅运行。
```

我们为什么要使用CloudWatch？
```
监控的一种方式？ 帮助我们及时预警，通知并分析错误错误。
```

CloudWatch中的metrics是什么？包括哪些种类？我们可以如何使用metrics？
```
Metrics(指标) 代表一个发布到 CloudWatch 的时间排序的数据点集。
可将指标视为要监控的变量，而数据点代表该变量随时间变化的值。
例如，特定 EC2 实例的 CPU 使用率是 Amazon EC2 提供的一个指标。数据点本身可来自于您从中收集数据的任何应用程序或业务活动。
```

```
免费：许多AWS服务提供资源（例如 Amazon EC2 实例、Amazon EBS 卷和 Amazon RDS 数据库实例）的免费指标。
收费：还可以启用对某些资源 (例如 Amazon EC2 实例) 的详细监控，或发布您自己的应用程序指标。对于自定义指标，您可以按照您选择的任何顺序和任何速率添加数据点。您可以按一组有序的时间序列数据来检索关于这些数据点的统计数据。
```

```
监控？
```

CloudWatch Events是什么？可以应用在那些场景。
```
Amazon CloudWatch Events 提供几乎实时的系统事件流，这些事件描述 Amazon Web Services 中的更改（Amazon) 资源的费用。
通过使用可快速设置的简单规则，您可以匹配事件并将事件路由到一个或多个目标函数或流。CloudWatch 事件会随着运营变化的发生而感知这些变化。
CloudWatch Events 将响应这些操作更改并在必要时采取纠正措施，方式是发送消息以响应环境、激活函数、进行更改并捕获状态信息。

您可以将以下内容配置为Amazon服务作为 CloudWatch 事件的目标：
Amazon EC2 实例
Amazon Lambda 函数
Amazon Kinesis Data Streams 中的流
Amazon Kinesis Data Firehose 中的配送流
Amazon CloudWatch Logs 中的日志组
Amazon ECS 任务
Systems Manager
Systems Manager Automation
Amazon Batch 个作业
Step Functions 状态机
CodePipeline 中的管道
CodeBuild 项目
Amazon Inspector 评估模板
Amazon SNS 主题
Amazon SQS 队列
内置目标：EC2 CreateSnapshot API call、EC2 RebootInstances API call、EC2 StopInstances API call 和 EC2 TerminateInstances API call。
另一个 Amazon 账户的默认事件总线
```

相关概念理解：metrics，periods，namespace，count，dimensions，statistics。
```
Metric -> cloudwatch中时间顺序排列的一组数据点，可以看作要监控的变量。
指标由名称，名称空间和零个或多个维度唯一定义。
Metrics are uniquely defined by a name, a namespace, and zero or more dimensions.
```


```
- metrices
指标是 CloudWatch 中的基本概念。指标代表一个发布到 CloudWatch 的时间排序的数据点集。可将指标视为要监控的变量，而数据点代表该变量随时间变化的值。例如，特定 EC2 实例的 CPU 使用率是 Amazon EC2 提供的一个指标。数据点本身可来自于您从中收集数据的任何应用程序或业务活动。
默认情况下，许多AWS服务提供资源（例如 Amazon EC2 实例、Amazon EBS 卷和 Amazon RDS 数据库实例）的免费指标。收费后，您还可以启用对某些资源 (例如 Amazon EC2 实例) 的详细监控，或发布您自己的应用程序指标。对于自定义指标，您可以按照您选择的任何顺序和任何速率添加数据点。您可以按一组有序的时间序列数据来检索关于这些数据点的统计数据。
指标仅存在于创建它们的区域中。指标无法删除，但如果在 15 个月后没有向指标发布新数据，这些指标将自动过期。依据滚动机制，15 个月之前的数据点将过期；当新的数据点进入时，15 个月之前的数据将被丢弃。
指标是通过一个名称、一个命名空间以及零个或多个维度进行唯一定义的。指标中的每个数据点都有一个时间戳和一个度量单位（可选）。您可以从 CloudWatch 检索任何指标的统计数据。

- periods
Period是与特定 Amazon CloudWatch 统计信息关联的时间的长度。
每项统计信息代表在指定时间段内对收集的指标数据的聚合。
时间段以秒为单位定义，时间段的有效值为 1、5、10、30 或 60 的任意倍数。
例如，要指定六分钟的时间段，时间段的值应为 360。通过改变时间段的长度可以调整数据聚合的方式。时间段可短至一秒，也可长至一天 (86400 秒)。默认值为 60 秒。

- namespace
命名空间是 CloudWatch 指标的容器。不同命名空间中的指标彼此独立，因此来自不同应用程序的指标不会被错误地聚合到相同的统计信息中。
无默认命名空间。您必须为发布到 CloudWatch 的每个数据点指定命名空间。
这些区域有：AWS命名空间通常使用以下命名约定：AWS/service。 例如，Amazon EC2 使用AWS/EC2命名空间。

- count
数据点计数 (数量) 用于统计信息的计算。

- dimensions
维度是一个名称/值对，它是指标标识的一部分。您可以为一个指标分配最多 10 个维度。
每个指标包含用于描述该指标的特定特征，您可以将维度理解为这些特征的类别。维度可以帮助您设计统计数据计划的结构。因为维度是指标的唯一标识符的一部分，因此无论您在何时向一个指标添加唯一名称/值对，都会创建该指标的一个新变体。
AWS向 CloudWatch 发送数据的服务将向每个指标附加维度。您可以使用维度筛选 CloudWatch 返回的结果。例如，您可通过在搜索指标时指定 InstanceId 维度来获取特定 EC2 实例的统计数据。
对于由某些AWS服务（例如 Amazon EC2），CloudWatch 可以聚合多个维度中的数据。例如，如果您在AWS/EC2命名空间但不指定任何维度，CloudWatch 将汇总指定指标的所有数据以创建您请求的统计数据。CloudWatch 不会为您的自定义指标跨多个维度进行汇总。

- statistices
统计数据是指定时间段内的指标数据汇总。
CloudWatch 提供统计数据的依据是您的自定义数据所提供的指标数据点，或其他AWS服务添加到 CloudWatch。
聚合通过使用命名空间、指标名称、维度以及数据点度量单位在您指定的时间段内完成。下表介绍了可用的统计信息。
```
Quick Summary:
```
Namespaces
- Metrics 的容器 (Container), 就是用來分類 AWS 服務的, 用 slash / 區隔. 像是 AWS/EC2, AWS/DynamoDB.

Metrics
- Metrics 意思是 度量, 是一個時間軸 (time-base) 的資料集合. 像是 ELB 的 HealthyHostCount, RequestCount, SurgeQueueLength 都叫做 Metrics.

Dimensions
- 量測的資源對象 (ARN)，是 Key/Value 呈現，像是 Name=InstanceId,Value=${INSTANCE_ID}, Name=LoadBalancerName,Value=${ARN_ID}

Statistics
- 時間範圍之內的統計方式，包含了：Sum, Minimum, Maximum, and SampleCount.
```
