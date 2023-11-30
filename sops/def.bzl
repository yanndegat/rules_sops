load("@rules_sops//sops/rules:sops.bzl", _sops_age_encrypt = "sops_age_encrypt")

BZL_FILES = [
    "**/*.bazel",
    "**/WORKSPACE*",
    "**/BUILD",
]

def sops_age_encrypt(name, src, age_key, opts = [], tags = None):
    _sops_age_encrypt(
        name = name,
        src = src,
        age_key = age_key,
        opts = opts,
        tags = tags,
        visibility = ["//visibility:public"],
    )
