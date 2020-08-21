# Adapter le nom à l'usage
# un nom doit être unique pour un compte AWS
# donné
resource "aws_key_pair" "kp_wp1" {
  key_name = "kp_wp1"
  # généré par ssh-keygen ...
  public_key = file("../ssh-keys/id_rsa_wp1.pub")
}

resource "aws_security_group" "sg_wp_app" {
  name   = "sg_wp_app"
  vpc_id = aws_vpc.network_wp.id
  # en entrée
  # autorise ssh de partout
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # autorise http de partout
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # autorise icmp (ping)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_wp_bdd" {
  name   = "sg_wp_bdd"
  vpc_id = aws_vpc.network_wp.id
  # en entrée
  # autorise ssh de partout
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # autorise connexion avec l'app
  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["192.168.20.0/24"]
  }

  # autorise icmp (ping)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "wp_app" {
  # Ubuntu 18.04 fournie par AWS
  ami                         = "ami-0bcc094591f354be2"
  instance_type               = "t2.micro"
  key_name                    = "kp_wp1"
  vpc_security_group_ids      = [aws_security_group.sg_wp_app.id]
  subnet_id                   = aws_subnet.subnet_wp.id
  private_ip                  = "192.168.10.20"
  associate_public_ip_address = "true"
  user_data                   = file("../Scripts/wp_app_init.sh")
  tags = {
    Name = "wp_app"
  }
}

resource "aws_instance" "wp_bdd" {
  # Ubuntu 18.04 fournie par AWS
  ami                         = "ami-0bcc094591f354be2"
  instance_type               = "t2.micro"
  key_name                    = "kp_wp1"
  vpc_security_group_ids      = [aws_security_group.sg_wp_bdd.id]
  subnet_id                   = aws_subnet.subnet_wp.id
  private_ip                  = "192.168.10.30"
  associate_public_ip_address = "true"
  user_data                   = file("../Scripts/wp_bdd_init.sh")
  tags = {
    Name = "wp_bdd"
  }
}

output "wp_app_ip" {
  value = "${aws_instance.wp_app.*.public_ip}"
}

output "wp_bdd_ip" {
  value = "${aws_instance.wp_bdd.*.public_ip}"
}