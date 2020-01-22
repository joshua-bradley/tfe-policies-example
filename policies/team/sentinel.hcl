policy "enforce-mandatory-tags" {
    enforcement_level = "hard-mandatory"
}

policy "limit-cost-by-workspace-type" {
    enforcement_level = "soft-mandatory"
}

policy "aws-restrict-instance-type" {
    enforcement_level = "soft-mandatory"
}
