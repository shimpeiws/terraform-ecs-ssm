resource "aws_ecs_cluster" "ecs-cluster" {
  name = "terraform-ecs-ssm-${var.env_name}"
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "/ecs/terraform-ecs-ssm-${var.env_name}"
  retention_in_days = 180
}

data "aws_iam_policy" "ecs-task-execution-role-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs-task-execution" {
  source_json = data.aws_iam_policy.ecs-task-execution-role-policy.policy
}

resource "aws_ecs_task_definition" "ecs-task-definition" {
  family                   = "terraform-ecs-ssm-${var.env_name}"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions =<<DEFINITION
  [
    {
      "name": "ecs-task-definition",
      "image": "${var.image_uri}",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "terraform-ecs-ssm-${var.env_name}",
          "awslogs-group": "${aws_cloudwatch_log_group.log-group.name}"
        }
      }
    }
  ]
  DEFINITION

  task_role_arn =  var.iam_role_arn
  execution_role_arn = var.iam_role_arn
}

resource "aws_ecs_service" "ecs-service" {
  name                              = "terraform-ecs-ssm-${var.env_name}"
  cluster                           = aws_ecs_cluster.ecs-cluster.arn
  task_definition                   = aws_ecs_task_definition.ecs-task-definition.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"

  network_configuration {
    assign_public_ip = true
    security_groups  = [var.security_group_id]

    subnets = [
      var.subnet_public_0,
      var.subnet_private_0,
      var.subnet_private_1
    ]
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

