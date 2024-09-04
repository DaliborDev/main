load(":actions.bzl", "go_build_stdlib", "go_compile", "go_link")


########################################################################################
#                                                                             
#       88                       88                                                  
#       88                       88                                                  
#       88                       88                                                  
#       88,dPPYba,    ,adPPYba,  88  8b,dPPYba,    ,adPPYba,  8b,dPPYba,  ,adPPYba,  
#       88P'    "8a  a8P_____88  88  88P'    "8a  a8P_____88  88P'   "Y8  I8[    ""  
#       88       88  8PP"""""""  88  88       d8  8PP"""""""  88           `"Y8ba,   
#       88       88  "8b,   ,aa  88  88b,   ,a8"  "8b,   ,aa  88          aa    ]8I  
#       88       88   `"Ybbd8"'  88  88`YbbdP"'    `"Ybbd8"'  88          `"YbbdP"'  
#                                    88                                              
#                                    88                                              
#
########################################################################################

def _go_binary_impl(ctx):
  # Declare an output file for the main package and compile it from srcs. All
  # our output files will start with a prefix to avoid conflicting with
  # other rules.
  main_archive = ctx.actions.declare_file("{name}_/main.a".format(name = ctx.label.name))
  go_compile(
    ctx,
    srcs = ctx.files.srcs,
    stdlib = ctx.files._stdlib,
    out = main_archive,
  )

  # Declare an output file for the executable and link it. Note that output
  # files may not have the same name as the rule, so we still need to use the
  # prefix here.
  executable_path = "{name}_/{name}".format(name=ctx.label.name)
  executable = ctx.actions.declare_file(executable_path)
  go_link(
    ctx,
    main = main_archive,
    stdlib = ctx.files._stdlib,
    out = executable,
  )

  # Return the DefaultInfo provider. This tells Bazel what files should be
  # built when someone asks to build a go_binary rule. It also says which
  # file is executable (in this case, there's only one).
  return [DefaultInfo(
    files = depset([executable]),
    executable = executable,
  )]

def _go_stdlib_impl(ctx):
    # Declare two outputs: an importcfg file, and a packages directory.
    # Then build them both with go_build_stdlib. See the explanation there.
    prefix = ctx.label.name + "%/"
    importcfg = ctx.actions.declare_file(prefix + "importcfg")
    packages = ctx.actions.declare_directory(prefix + "packages")
    go_build_stdlib(
        ctx,
        out_importcfg = importcfg,
        out_packages = packages,
    )
    return [DefaultInfo(files = depset([importcfg, packages]))]


############################################################################
#
#       88888888ba                88                                                                                                           
#       88      "8b               88                                                                                                           
#       88      ,8P               88                                                                                                           
#       88aaaaaa8P'  88       88  88   ,adPPYba,  ,adPPYba,                                                                                    
#       88""""88'    88       88  88  a8P_____88  I8[    ""                                                                                    
#       88    `8b    88       88  88  8PP"""""""   `"Y8ba,                                                                                     
#       88     `8b   "8a,   ,a88  88  "8b,   ,aa  aa    ]8I                                                                                    
#       88      `8b   `"YbbdP'Y8  88   `"Ybbd8"'  `"YbbdP"'                                                                                    
#
############################################################################

go_binary = rule(
  implementation = _go_binary_impl,
  attrs = {
    "srcs": attr.label_list(
      allow_files = [".go"],
      doc = "Source files to compile for the main package of this binary",
    ),
    "_stdlib": attr.label(
      default = "//bazel:stdlib",
    ),
  },
  doc = "Builds an executable program from Go source code",
  executable = True
)

# go_stdlib is an internal rule that compiles the Go standard library
# using source files and tools from a downloaded Go distribution.
#
# This rule was not part of the original tutorial series. Instead, we depended
# on precompiled packages that shipped with the Go distribution. The
# precompiled standard library was removed in Go 1.20 in order to reduce
# download sizes. Unfortunately, that meant this tutorial needed a rule that
# compiles the standard library, making it much more complicated.
#
# go_stdlib produces two outputs:
#
#     1. An importcfg file mapping each package's import path to a relative
#        file path within Bazel's execroot. This is read by the compiler and
#        linker to locate files for imported packages.
#     2. A packages directory containing compiled packages. These packages
#        are read by the compiler (for export data) and the linker
#        (for linking).
#
# There is a single go_stdlib target, //:go_stdlib. All other Go rules
# have a hidden dependency on that target.
go_stdlib = rule(
    implementation = _go_stdlib_impl,
    doc = "Builds the Go standard library",
)