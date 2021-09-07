resource "aws_kms_key" "luna_kms" {
  description             = "KMS key for lottery system"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_kms_alias" "luna_kms" {
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.luna_kms.key_id
}

//resource "aws_kms_grant" "default" {
//  name              = "luna-grant"
//  key_id            = aws_kms_key.luna_kms.key_id
//  grantee_principal = module.luna_lottery_recommendation_role.iam_role_arn
//  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
//}
