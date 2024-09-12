GoLibraryInfo = provider(
  doc = "Info about go library",
  fields = {
    "info": "",
    "deps": "A depset of info structs for this library's dependencies",
    "files": "",
  },
)

GoStdLibInfo = provider(
  doc = "Info about go stdlib",
  fields = {
    "importcfg": "",
    "packages": "",
    "files": "",
  },
)