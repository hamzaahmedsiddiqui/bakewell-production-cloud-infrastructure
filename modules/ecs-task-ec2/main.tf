resource "aws_ecs_task_definition" "backend" {
  family                   = "bakewell-prod-backend"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${var.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 5050
          hostPort      = 5050
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = "bakewell-prod-db.c4uo8nhbxbkf.us-west-2.rds.amazonaws.com"
        },
        {
          name  = "DB_USER"
          value = var.db_user
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_PORT"
          value = "5432"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = "us-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}