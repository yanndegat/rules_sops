SopsInfo = provider(
    doc = "Information about how to invoke Sops.",
    fields = ["sops"],
)

def _sops_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        runtime = SopsInfo(
            sops = ctx.file.sops,
        ),
    )
    return [toolchain_info]

sops_toolchain = rule(
    implementation = _sops_toolchain_impl,
    attrs = {
        "sops": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "target",
        ),
    },
)

def register_sops_toolchain(visibility):
    toolchain_typename = "toolchain_type"
    native.toolchain_type(
        name = toolchain_typename,
        visibility = visibility,
    )

    name = "linux_amd64"
    toolchain_name = "{}_toolchain".format(name)

    sops_toolchain(
        name = "{}_impl".format(name),
        sops = "@sops//:runtime",
    )

    native.toolchain(
        name = toolchain_name,
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        target_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        toolchain = ":{}_impl".format(name),
        toolchain_type = ":{}".format(toolchain_typename),
        visibility = visibility,
    )


def _download_impl(ctx):
    ctx.report_progress("Downloading sops")

    ctx.template(
        "BUILD",
        Label("@rules_sops//sops/toolchains/sops:BUILD.toolchain.tpl"),
        executable = False,
    )

    url_template = "https://github.com/mozilla/sops/releases/download/v{version}/sops-v{version}.{os}.{arch}"
    url = url_template.format(version = ctx.attr.version, os = ctx.attr.os, arch = ctx.attr.arch)

    ctx.download(
        url = url,
        sha256 = ctx.attr.sha256,
        output = "sops",
        executable = True,
    )

    return {
        "version": ctx.attr.version,
        "sha256": ctx.attr.sha256,
        "os": ctx.attr.os,
        "arch": ctx.attr.arch,
        "name": ctx.attr.name,
    }

sops_download = repository_rule(
    implementation = _download_impl,
    attrs = {
        "version": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "os": attr.string(mandatory = True),
        "arch": attr.string(mandatory = True),
    },
)
