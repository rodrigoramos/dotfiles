complete --command nvm --exclusive
complete --command nvm --exclusive --long version --description "Print version"
complete --command nvm --exclusive --long help --description "Print help"
complete --command nvm --exclusive --long silent --description "Suppress standard output"

complete --command nvm --exclusive --condition __fish_use_subcommand --arguments install --description "Download and activate the specified Node version"
complete --command nvm --exclusive --condition __fish_use_subcommand --arguments use --description "Activate the specified Node version in the current shell"
complete --command nvm --exclusive --condition __fish_use_subcommand --arguments version --description "Resolve the given description to a single local version"
complete --command nvm --exclusive --condition __fish_use_subcommand --arguments version-remote --description "Resolve the given description to a single remote version"
complete --command nvm --exclusive --condition __fish_use_subcommand --arguments list --description "List installed Node versions"
complete --command nvm --exclusive --condition __fish_use_subcommand --arguments list-remote --description "List available Node versions to install"
complete --command nvm --exclusive --condition __fish_use_subcommand --arguments current --description "Print the currently-active Node version"
complete --command nvm --exclusive --condition __fish_use_subcommand --arguments uninstall --description "Uninstall the specified Node version"
complete --command nvm --exclusive --condition __fish_use_subcommand --arguments reinstall-packages --description "Reinstall global `npm` packages contained in the specified version to the current version"
