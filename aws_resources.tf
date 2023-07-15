# module "aws_server" {
#   source = "./Modules/Aws_Module"
#   providers = {
#     aws = aws.us
#   }
# }

# output "aws_server_public_ip" {
#   value = module.aws_server.server_public_ip
# }