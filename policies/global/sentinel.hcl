policy "aws-restrict-ingress-cidr" {
    enforcement_level = "hard-mandatory"
}

policy "azure-restrict-ingress-cidr" {
    enforcement_level = "soft-mandatory"
}

policy "gcp-restrict-ingress-cidr" {
    enforcement_level = "soft-mandatory"
}
