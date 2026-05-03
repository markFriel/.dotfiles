# ~/.Rprofile — global R startup settings

options(
  repos = c(CRAN = "https://cloud.r-project.org"),
  pak.no_extra_messages = TRUE,
  warn = 1
)

# Add global dev library to the search path for all sessions (renv and non-renv).
# Dev tools (vscDebugger, devtools, styler, etc.) live here so they are always
# available without being project dependencies or appearing in renv.lock.
local({
  globallib <- path.expand("~/.R/globallib")
  if (dir.exists(globallib)) {
    .libPaths(c(globallib, .libPaths()))
    Sys.setenv(RENV_CONFIG_EXTERNAL_LIBRARIES = globallib)
  }
})

# Wire languageserver to use styler for "Format Document" in VS Code/Cursor.
if (requireNamespace("styler", quietly = TRUE)) {
  options(
    languageserver.formatting_style = function(options) {
      styler::tidyverse_style(indent_by = options$tabSize)
    }
  )
}
