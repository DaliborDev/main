load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def go_rules_dependencies():
  """Declares external repositories that rules_go_simple depends on. This
  function should be loaded and called from WORKSPACE files."""

  # bazel_skylib is a set of libraries that are useful for writing
  # Bazel rules. We use it to handle quoting arguments in shell commands.
  _maybe(
        git_repository,
        name = "bazel_skylib",
        remote = "https://github.com/bazelbuild/bazel-skylib",
        commit = "fa66e6b15b06070c0c6467983b4892bc33dc9145",
    )

def _maybe(rule, name, **kwargs):
    """Declares an external repository if it hasn't been declared already."""
    if name not in native.existing_rules():
        rule(name = name, **kwargs)
