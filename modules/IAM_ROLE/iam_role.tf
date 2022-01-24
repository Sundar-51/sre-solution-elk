#IAM ROLE FOR EC2 INSTANCES TO READ OTHER EC2 INSTANCE PRIVATE-IP
resource "aws_iam_role" "ec2role" {
  name = var.iam_role_name

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
resource "aws_iam_policy" "ec2_read_only_policy" {
  name        = var.iam_policy_name
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
#ATTACHING IAM POLICY TO THE ROLE
resource "aws_iam_policy_attachment" "ec2policy-attach" {
  name       = "ec2-policy-attachment"
  roles      = [var.iam_role_name]
  policy_arn = aws_iam_policy.ec2_read_only_policy.arn
}
#INSTANCE PROFILE TO ATTACH THE ROLE FOR THE INSTANCES
resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.instance_profile_name
  role = var.iam_role_name
}

