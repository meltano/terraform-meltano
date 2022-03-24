locals {
  name = "meltano-${var.environment}-${random_string.suffix.result}"
}