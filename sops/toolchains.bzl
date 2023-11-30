load("@rules_sops//sops/toolchains/sops:toolchain.bzl", "register_sops_toolchain")

def register_toolchains():
    register_sops_toolchain(visibility = ["//visibility:public"])
