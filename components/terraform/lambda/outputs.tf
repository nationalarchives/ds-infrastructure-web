output "process_submitted_files_queue_arn" {
  value = var.environment == "live" ? aws_sqs_queue.process_submitted_files_queue[0].arn : null
}

output "process_submitted_files_queue_url" {
  value = var.environment == "live" ? aws_sqs_queue.process_submitted_files_queue[0].id : null
}