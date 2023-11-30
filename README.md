# Sops test Rule

The sops rules are useful to encrypt files using sops.

## Getting Started

To import rules_sops in your project, you first need to add it to your `MODULE.bazel` file:

```python
bazel_dep(name = "rules_sops", version = "0.0.1")
git_override(
    module_name = "rules_sops",
    remote      = "https://github.com/yanndegat/rules_sops",
    commit      = "",
)
```

Once you've imported the rule set , you can then load the tf rules in your `BUILD` files with:

```python
load("@rules_sops//sops:def.bzl", "sops_age_encrypt")

sops_age_encrypt(
    name = "encfile",
    src = ":test.yaml",
    age_key = "age1...",
    opts = ["--ignore-mac", "--encrypted-regex", "^(data|stringData)$"],
)
```
