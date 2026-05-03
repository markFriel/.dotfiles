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
  dir.create(globallib, recursive = TRUE, showWarnings = FALSE)
  .libPaths(c(globallib, .libPaths()))
  Sys.setenv(RENV_CONFIG_EXTERNAL_LIBRARIES = globallib)
  options(renv.config.external.libraries = globallib)
})

# Load the isolated languageserver library so it is visible in renv projects.
# languageserversetup installs languageserver to a private library that
# r.libPaths (broken in vscode-R with renv) cannot reach but this can.
if (requireNamespace("languageserversetup", quietly = TRUE)) {
  languageserversetup::languageserver_load()
}

# Wire languageserver to use styler for "Format Document" in VS Code/Cursor.
if (requireNamespace("styler", quietly = TRUE)) {
  options(
    languageserver.formatting_style = function(options) {
      styler::tidyverse_style(indent_by = options$tabSize)
    }
  )
}
