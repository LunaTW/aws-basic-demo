{
    "AWSTemplateFormatVersion": "2010-09-09",
    "Resources" : {
        "EmailSubscriptionSNSTopic": {
            "Type" : "AWS::SNS::Subscription",
            "Properties" : {
                "TopicArn" : "${topicArn}",
                "Protocol" : "${protocol}",
                "Endpoint" : "${endpoint}"
            }
        }
    }
}
