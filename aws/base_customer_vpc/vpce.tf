data "aws_vpc" "prod" {
  id    = var.vpc_id
}

resource "aws_vpc_endpoint" "backend_rest" {
  vpc_id             = var.vpc_id
  service_name       = var.workspace_vpce_service
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.dataplane_vpce.id]
  subnet_ids         = [aws_subnet.dataplane_vpce.id]
  // run terraform apply twice when configuring PrivateLink - see this outstanding issue for understanding why this is required - https://github.com/hashicorp/terraform-provider-aws/issues/7148
  // Run 1 - comment the `private_dns_enabled` line
  // Run 2 - uncomment the `private_dns_enabled` line
  // private_dns_enabled = var.private_dns_enabled
  depends_on         = [aws_subnet.dataplane_vpce]
}

resource "aws_vpc_endpoint" "relay" {
  vpc_id             = var.vpc_id
  service_name       = var.relay_vpce_service
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.dataplane_vpce.id]
  subnet_ids         = [aws_subnet.dataplane_vpce.id]
  // run terraform apply twice when configuring PrivateLink - see this outstanding issue for understanding why this is required - https://github.com/hashicorp/terraform-provider-aws/issues/7148
  // Run 1 - comment the `private_dns_enabled` line
  // Run 2 - uncomment the `private_dns_enabled` line
  // private_dns_enabled = var.private_dns_enabled
  depends_on         = [aws_subnet.dataplane_vpce]
}


resource "databricks_mws_vpc_endpoint" "backend_rest_vpce" {
  provider            = databricks.mws
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.backend_rest.id
  vpc_endpoint_name   = "${local.prefix}-vpc-backend-${var.vpc_id}"
  region              = var.region
  depends_on          = [aws_vpc_endpoint.backend_rest]
}

resource "databricks_mws_vpc_endpoint" "relay" {
  provider            = databricks.mws
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.relay.id
  vpc_endpoint_name   = "${local.prefix}-vpc-relay-${var.vpc_id}"
  region              = var.region
  depends_on          = [aws_vpc_endpoint.relay]
}
