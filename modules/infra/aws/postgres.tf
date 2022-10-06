resource "aws_db_subnet_group" "this" {
  name       = "${var.deployment_id}-b-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "boundary-database"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.deployment_id}-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "13.7"
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.this.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_security_group" "rds" {
  name   = "${var.deployment_id}-b-rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_id}-b-rds-sg"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.deployment_id}-grp"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "null_resource" "create-db" {
  provisioner "remote-exec" {
    inline = [
      /* "sudo apt-get install -y postgresql-client", */
      /* "sleep 10", */
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'create database boundary;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c \"create user ${var.boundary_db_username} with password '${var.boundary_db_password}'\"",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'grant all privileges on database boundary to ${var.boundary_db_username};'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'create role analyst noinherit;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'GRANT CONNECT ON DATABASE postgres TO analyst;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'grant usage on schema public to analyst;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'grant select on all tables in schema public to analyst;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'grant usage on all sequences in schema public to analyst;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'grant execute on all functions in schema public to analyst;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'create role dba noinherit;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'GRANT CONNECT ON DATABASE postgres TO dba;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'grant all privileges on database postgres to dba;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dba;'",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c \"create table country(code varchar, name varchar);\"",
      "PGPASSWORD=postgres psql -h ${aws_db_instance.this.address} -U ${aws_db_instance.this.username} -c \"insert into country values('SG', 'Singapore');\"",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.bastion.public_ip
    private_key = file("${path.root}/private-key/rp-key.pem")
  }
}



//sudo apt-get install -y postgresql-client

/*
resource "postgresql_database" "boundary" {
  name              = "boundary"
  allow_connections = true
}

resource "postgresql_role" "boundary" {
  name     = "boundary"
  login    = true
  password = "boundary"
}

resource "postgresql_grant" "database" {
  database    = "boundary"
  role        = "boundary"
  schema      = "public"
  object_type = "database"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER", "CREATE", "CONNECT", "TEMPORARY", "EXECUTE", "USAGE"]
}

provider "postgresql" {
  host            = aws_db_instance.this.address
  port            = aws_db_instance.this.port
  database        = "postgres"
  username        = aws_db_instance.this.username
  password        = "postgres"
  sslmode         = "disable"
  connect_timeout = 15
}
*/

