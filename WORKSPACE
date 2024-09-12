workspace(name = "main")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Go toolchain
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "67b4d1f517ba73e0a92eb2f57d821f2ddc21f5bc2bd7a231573f11bd8758192e",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.50.0/rules_go-v0.50.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.50.0/rules_go-v0.50.0.zip",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains")
load("//bazel:deps.bzl", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.23.0")
