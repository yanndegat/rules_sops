def _age_encrypt_impl(ctx):
    out = ctx.actions.declare_file("sops-{}".format(ctx.file.src.basename))

    ctx.actions.run(
        inputs    = [ctx.file.src],
        outputs    = [out],
        executable = ctx.toolchains["@rules_sops//:toolchain_type"].runtime.sops,
        tools      = [ctx.toolchains["@rules_sops//:toolchain_type"].runtime.sops],
        arguments  = ctx.attr.opts + [
            "--age", ctx.attr.age_key,
            "--output", out.path,
            "--encrypt", ctx.file.src.short_path,
        ],
    )

    return [
        DefaultInfo(
            files = depset([out]),
        ),
    ]

sops_age_encrypt = rule(
    implementation = _age_encrypt_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        "age_key": attr.string(
            mandatory = True,
        ),
        "opts": attr.string_list( default = [""]),
    },
    toolchains = ["@rules_sops//:toolchain_type"],
)
