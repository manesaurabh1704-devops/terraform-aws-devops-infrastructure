output "public_subnet" {

  value = aws_subnet.public_subnet.id

}

output "public_subnet_2" {

  value = aws_subnet.public_subnet_2.id

}

output "private_subnet" {

  value = aws_subnet.private_subnet.id

}
