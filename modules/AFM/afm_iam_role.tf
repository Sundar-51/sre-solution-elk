#IAM ROLE FOR EC2 INSTANCES TO READ OTHER EC2 INSTANCE PRIVATE-IP
resource "aws_iam_role" "ec2-afm-role" {
  name = var.afm_iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
#IAM POLICY TO READ- INSTANCES
resource "aws_iam_policy" "afm_ec2_read_only_policy" {
  name        = var.afm_iam_policy_name
  description = "This IAM policy allows EC2 instances read permissions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "*"
        }, 
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
EOF
}
#
resource "aws_iam_policy" "metric_beat_policy" {
  name        = var.iam_metricbeat_policy_name
  description = "This IAM policy allows EC2 instances metricbeat read permissions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "sqs:ReceiveMessage"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "sqs:ChangeMessageVisibility",
            "Resource": "arn:aws:sqs:us-east-1:123456789012:test-fb-ks"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "sqs:DeleteMessage",
            "Resource": "arn:aws:sqs:us-east-1:123456789012:test-fb-ks"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "sqs:ListQueues",
                "tag:GetResources",
                "ec2:DescribeInstances",
                "cloudwatch:GetMetricData",
                "ec2:DescribeRegions",
                "iam:ListAccountAliases",
                "sts:GetCallerIdentity",
                "cloudwatch:ListMetrics"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
#
resource "aws_iam_policy" "function_beat_policy" {
  name        = var.iam_function_beat_policy_name
  description = "This IAM policy allows EC2 instances metricbeat read permissions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStackResources",
                "cloudformation:GetTemplate",
                "cloudformation:UpdateStack",
                "cloudformation:ValidateTemplate",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:DeleteRolePolicy",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:PassRole",
                "iam:PutRolePolicy",
                "lambda:AddPermission",
                "lambda:CreateFunction",
                "lambda:CreateEventSourceMapping",
                "lambda:DeleteFunction",
                "lambda:DeleteEventSourceMapping",
                "lambda:GetEventSourceMapping",
                "lambda:GetFunction",
                "lambda:GetFunctionConfiguration",
                "lambda:PutFunctionConcurrency",
                "lambda:RemovePermission",
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration",
                "logs:CreateLogGroup",
                "logs:DeleteLogGroup",
                "logs:DeleteSubscriptionFilter",
                "logs:DescribeLogGroups",
                "logs:PutSubscriptionFilter",
                "s3:CreateBucket",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
/*resource "aws_iam_policy" "trust_policy" {
  name        = var.iam_trust_policy_name
  description = "This IAM policy allows EC2 instances metricbeat read permissions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}*/
#ATTACHING IAM POLICY TO THE ROLE
resource "aws_iam_policy_attachment" "ec2policy-attach" {
  name       = "ec2-policy-attachment"
  roles      = [var.afm_iam_role_name]
  policy_arn = aws_iam_policy.afm_ec2_read_only_policy.arn
}
resource "aws_iam_policy_attachment" "ec2-metric-policy-attach" {
  name       = "ec2-metric-policy-attachment"
  roles      = [var.afm_iam_role_name]
  policy_arn = aws_iam_policy.metric_beat_policy.arn
}
resource "aws_iam_policy_attachment" "ec2-function-policy-attach" {
  name       = "ec2-function-policy-attachment"
  roles      = [var.afm_iam_role_name]
  policy_arn = aws_iam_policy.function_beat_policy.arn
}
/*resource "aws_iam_policy_attachment" "ec2-trust-policy-attach" {
  name       = "ec2-trust-policy-attachment"
  roles      = [var.afm_iam_role_name]
  policy_arn = aws_iam_policy.trust_policy.arn
}*/

#INSTANCE PROFILE TO ATTACH THE ROLE FOR THE INSTANCES
resource "aws_iam_instance_profile" "afm_profile" {
  name = var.afm_instance_profile_name
  role = var.afm_iam_role_name
}

