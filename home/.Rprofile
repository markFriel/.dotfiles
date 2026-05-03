# ~/.Rprofile — global R startup settings

options(
  repos = c(CRAN = "https://cloud.r-project.org"),
  pak.no_extra_messages = TRUE,
  warn = 1
)

# Always expose the global dev library to renv projects.
# Dev tools (vscDebugger, etc.) live here so they never need to be added
# to renv.lock — they are available in every project without being project deps.
local({
  globallib <- path.expand("~/.R/globallib")
  if (dir.exists(globallib)) {
    Sys.setenv(RENV_CONFIG_EXTERNAL_LIBRARIES = globallib)
  }
})
