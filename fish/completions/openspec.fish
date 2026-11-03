# Fish completion script for OpenSpec CLI
# Auto-generated - do not edit manually

# Helper function to match the command path at the start of the invocation
function __fish_openspec_using_command_path
    set -l expected
    set -l value_flags
    set -l reading_value_flags 0
    for argument in $argv
        if test "$argument" = --
            set reading_value_flags 1
            continue
        end
        if test $reading_value_flags -eq 1
            set -a value_flags $argument
        else
            set -a expected $argument
        end
    end

    set -l tokens (commandline -opc)
    set -e tokens[1]
    set -l path
    set -l skip 0
    for token in $tokens
        if test $skip -eq 1
            set skip 0
            continue
        end
        if test "$token" = --no-color
            continue
        end
        if contains -- $token $value_flags
            set skip 1
            continue
        end
        if string match -q -- '-*' $token
            continue
        end
        set -a path $token
        if test (count $path) -eq (count $expected)
            break
        end
    end
    test (count $path) -eq (count $expected); or return 1
    for index in (seq (count $expected))
        test "$path[$index]" = "$expected[$index]"; or return 1
    end
    return 0
end

function __fish_openspec_no_subcommand
    set -l tokens (commandline -opc)
    set -e tokens[1]
    for token in $tokens
        if test "$token" != --no-color
            return 1
        end
    end
    return 0
end

function __fish_openspec_completing_option_value
    set -l current (commandline -ct)
    for option in $argv
        if string match -q -- "$option=*" "$current"
            return 0
        end
    end

    set -l tokens (commandline -opc)
    test (count $tokens) -gt 0; or return 1
    contains -- $tokens[-1] $argv
end

function __fish_openspec_complete_attached_short_path
    set -l option $argv[1]
    set -l current (commandline -ct)
    test "$current" != "$option"; or return 1
    string match -q -- "$option*" "$current"; or return 1
    set -l value (string sub -s (math (string length -- "$option") + 1) -- "$current")
    __fish_complete_path "$value"
end

function __fish_openspec_positional_index
    set -l target $argv[1]
    set -l depth $argv[2]
    set -l value_flags $argv[3..]
    set -l tokens (commandline -opc)
    set -e tokens[1]
    set -l count 0
    set -l options 1
    set -l skip 0
    for token in $tokens
        if test $skip -eq 1
            set skip 0
            continue
        end
        if test $options -eq 1
            if test "$token" = --
                set options 0
                continue
            end
            if contains -- $token $value_flags
                set skip 1
                continue
            end
            if string match -q -- '-*' $token
                continue
            end
        end
        set count (math $count + 1)
    end
    test $skip -eq 0; or return 1
    test $count -eq (math $target + $depth)
end
# Dynamic completion helpers

function __fish_openspec_changes
    openspec __complete changes 2>/dev/null | while read -l id desc
        printf '%s\t%s\n' "$id" "$desc"
    end
end

function __fish_openspec_specs
    openspec __complete specs 2>/dev/null | while read -l id desc
        printf '%s\t%s\n' "$id" "$desc"
    end
end

function __fish_openspec_items
    __fish_openspec_changes
    __fish_openspec_specs
end

function __fish_openspec_schemas
    openspec __complete schemas 2>/dev/null | while read -l id desc
        printf '%s\t%s\n' "$id" "$desc"
    end
end
complete -c openspec -l no-color -f -d 'Disable color output'
# init command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'init' -d 'Initialize OpenSpec in your project'
# update command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'update' -d 'Update OpenSpec instruction files'
# list command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'list' -d 'List items (changes by default, or specs with --specs)'
# view command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'view' -d 'Display an interactive dashboard of specs and changes'
# validate command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'validate' -d 'Validate changes and specs'
# show command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'show' -d 'Show a change or spec'
# archive command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'archive' -d 'Archive a completed change and update main specs'
# status command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'status' -d 'Display artifact completion status for a change'
# instructions command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'instructions' -d 'Output enriched instructions for artifacts, apply, or archive'
# templates command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'templates' -d 'Show resolved template paths for all artifacts in a schema'
# schemas command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'schemas' -d 'List available workflow schemas with descriptions'
# new command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'new' -d 'Create new items'
# store command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'store' -d 'Create and manage stores - standalone OpenSpec repos you register on this machine'
# context command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'context' -d 'Print the working context for the resolved OpenSpec root'
# doctor command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'doctor' -d 'Report relationship health for the resolved OpenSpec root'
# workset command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'workset' -d 'Compose, keep, and open personal working views (purely local)'
# feedback command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'feedback' -d 'Submit feedback about OpenSpec'
# change command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'change' -d 'Manage OpenSpec change proposals (deprecated)'
# spec command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'spec' -d 'Manage OpenSpec specifications'
# completion command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'completion' -d 'Manage shell completions for OpenSpec CLI'
# config command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'config' -d 'View and modify global OpenSpec configuration'
# schema command
complete -c openspec -n '__fish_openspec_no_subcommand' -f -a 'schema' -d 'Manage workflow schemas'

# init flags
complete -c openspec -n '__fish_openspec_using_command_path init' -f
complete -c openspec -n '__fish_openspec_using_command_path init' -l tools -r -f -d 'Configure AI tools non-interactively (e.g., "all", "none", or comma-separated tool IDs)'
complete -c openspec -n '__fish_openspec_using_command_path init' -l language -r -f -d 'Write new OpenSpec artifacts in this language'
complete -c openspec -n '__fish_openspec_using_command_path init' -l force -f -d 'Auto-cleanup legacy files without prompting'
complete -c openspec -n '__fish_openspec_using_command_path init' -l profile -r -f -a 'core' -d 'Override global config profile (core or custom)'
complete -c openspec -n '__fish_openspec_using_command_path init' -l profile -r -f -a 'custom' -d 'Override global config profile (core or custom)'
complete -c openspec -n '__fish_openspec_using_command_path init' -l no-animation -f -d 'Show a static welcome screen instead of the animated one'
complete -c openspec -n '__fish_openspec_using_command_path init' -l copilot-cloud -f -d 'Generate GitHub Copilot cloud coding-agent files (opt-in; default: prompt)'
complete -c openspec -n '__fish_openspec_using_command_path init' -l no-copilot-cloud -f -d 'Skip generating GitHub Copilot cloud coding-agent files'
complete -c openspec -n '__fish_openspec_using_command_path init; and __fish_openspec_positional_index 0 1 --tools --language --profile' -F

# update flags
complete -c openspec -n '__fish_openspec_using_command_path update' -f
complete -c openspec -n '__fish_openspec_using_command_path update' -l force -f -d 'Force update even when tools are up to date'
complete -c openspec -n '__fish_openspec_using_command_path update; and __fish_openspec_positional_index 0 1' -F

# list flags
complete -c openspec -n '__fish_openspec_using_command_path list' -f
complete -c openspec -n '__fish_openspec_using_command_path list' -l specs -f -d 'List specs instead of changes'
complete -c openspec -n '__fish_openspec_using_command_path list' -l changes -f -d 'List changes explicitly (default)'
complete -c openspec -n '__fish_openspec_using_command_path list' -l sort -r -f -a 'recent' -d 'Sort order: "recent" (default) or "name"'
complete -c openspec -n '__fish_openspec_using_command_path list' -l sort -r -f -a 'name' -d 'Sort order: "recent" (default) or "name"'
complete -c openspec -n '__fish_openspec_using_command_path list' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path list' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'

# view flags
complete -c openspec -n '__fish_openspec_using_command_path view' -f
complete -c openspec -n '__fish_openspec_using_command_path view' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'

# validate flags
complete -c openspec -n '__fish_openspec_using_command_path validate' -f
complete -c openspec -n '__fish_openspec_using_command_path validate' -l all -f -d 'Validate all changes and specs'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l changes -f -d 'Validate all changes'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l specs -f -d 'Validate all specs'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l archived -f -d 'Validate that archived changes have all tasks completed (for pre-commit linting)'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l report -r -f -a 'full' -d 'Select bulk report content'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l report -r -f -a 'findings' -d 'Select bulk report content'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l type -r -f -a 'change' -d 'Specify item type when ambiguous'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l type -r -f -a 'spec' -d 'Specify item type when ambiguous'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l strict -f -d 'Enable strict validation mode'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l json -f -d 'Output validation results as JSON'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l concurrency -r -f -d 'Max concurrent validations (defaults to env OPENSPEC_CONCURRENCY or 6)'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l no-interactive -f -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_command_path validate' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'
complete -c openspec -n '__fish_openspec_using_command_path validate; and __fish_openspec_positional_index 0 1 --report --type --concurrency --store' -a '(__fish_openspec_items)' -f

# show flags
complete -c openspec -n '__fish_openspec_using_command_path show' -f
complete -c openspec -n '__fish_openspec_using_command_path show' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path show' -l type -r -f -a 'change' -d 'Specify item type when ambiguous'
complete -c openspec -n '__fish_openspec_using_command_path show' -l type -r -f -a 'spec' -d 'Specify item type when ambiguous'
complete -c openspec -n '__fish_openspec_using_command_path show' -l no-interactive -f -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_command_path show' -l deltas-only -f -d 'Show only deltas (JSON only, change-specific)'
complete -c openspec -n '__fish_openspec_using_command_path show' -l requirements-only -f -d 'Alias for --deltas-only (deprecated, change-specific)'
complete -c openspec -n '__fish_openspec_using_command_path show' -l diff -f -d 'Show per-requirement diffs for delta specs (change-specific)'
complete -c openspec -n '__fish_openspec_using_command_path show' -l requirements -f -d 'Show only requirements, exclude scenarios (JSON only, spec-specific)'
complete -c openspec -n '__fish_openspec_using_command_path show' -l no-scenarios -f -d 'Exclude scenario content (JSON only, spec-specific)'
complete -c openspec -n '__fish_openspec_using_command_path show' -s r -l requirement -r -f -d 'Show specific requirement by ID (JSON only, spec-specific)'
complete -c openspec -n '__fish_openspec_using_command_path show' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'
complete -c openspec -n '__fish_openspec_using_command_path show; and __fish_openspec_positional_index 0 1 --type --requirement -r --store' -a '(__fish_openspec_items)' -f

# archive flags
complete -c openspec -n '__fish_openspec_using_command_path archive' -f
complete -c openspec -n '__fish_openspec_using_command_path archive' -s y -l yes -f -d 'Skip confirmation prompts'
complete -c openspec -n '__fish_openspec_using_command_path archive' -l skip-specs -f -d 'Skip spec update operations'
complete -c openspec -n '__fish_openspec_using_command_path archive' -l no-validate -f -d 'Skip validation (not recommended)'
complete -c openspec -n '__fish_openspec_using_command_path archive' -l json -f -d 'Output as JSON (non-interactive)'
complete -c openspec -n '__fish_openspec_using_command_path archive' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'
complete -c openspec -n '__fish_openspec_using_command_path archive; and __fish_openspec_positional_index 0 1 --store' -a '(__fish_openspec_changes)' -f

# status flags
complete -c openspec -n '__fish_openspec_using_command_path status' -f
complete -c openspec -n '__fish_openspec_using_command_path status' -l change -r -f -d 'Change name to show status for'
complete -c openspec -n '__fish_openspec_using_command_path status' -l all -f -d 'Show status for all active changes'
complete -c openspec -n '__fish_openspec_using_command_path status' -l schema -r -f -d 'Schema override'
complete -c openspec -n '__fish_openspec_using_command_path status' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path status' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'

# instructions flags
complete -c openspec -n '__fish_openspec_using_command_path instructions' -f
complete -c openspec -n '__fish_openspec_using_command_path instructions' -l change -r -f -d 'Change name'
complete -c openspec -n '__fish_openspec_using_command_path instructions' -l schema -r -f -d 'Schema override'
complete -c openspec -n '__fish_openspec_using_command_path instructions' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path instructions' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'
complete -c openspec -n '__fish_openspec_using_command_path instructions; and __fish_openspec_positional_index 0 1 --change --schema --store' -f

# templates flags
complete -c openspec -n '__fish_openspec_using_command_path templates' -f
complete -c openspec -n '__fish_openspec_using_command_path templates' -l schema -r -f -d 'Schema to use'
complete -c openspec -n '__fish_openspec_using_command_path templates' -l json -f -d 'Output as JSON'

# schemas flags
complete -c openspec -n '__fish_openspec_using_command_path schemas' -f
complete -c openspec -n '__fish_openspec_using_command_path schemas' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path schemas' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'

complete -c openspec -n '__fish_openspec_using_command_path new; and not __fish_openspec_using_command_path new change' -f -a 'change' -d 'Create a new change directory'

# new change flags
complete -c openspec -n '__fish_openspec_using_command_path new change' -f
complete -c openspec -n '__fish_openspec_using_command_path new change' -l description -r -f -d 'Description to add to README.md'
complete -c openspec -n '__fish_openspec_using_command_path new change' -l goal -r -f -d 'Optional goal metadata to store with the change'
complete -c openspec -n '__fish_openspec_using_command_path new change' -l schema -r -f -d 'Workflow schema to use'
complete -c openspec -n '__fish_openspec_using_command_path new change' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path new change' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'
complete -c openspec -n '__fish_openspec_using_command_path new change; and __fish_openspec_positional_index 0 2 --description --goal --schema --store' -f

complete -c openspec -n '__fish_openspec_using_command_path store; and not __fish_openspec_using_command_path store setup; and not __fish_openspec_using_command_path store register; and not __fish_openspec_using_command_path store unregister; and not __fish_openspec_using_command_path store remove; and not __fish_openspec_using_command_path store list; and not __fish_openspec_using_command_path store ls; and not __fish_openspec_using_command_path store doctor' -f -a 'setup' -d 'Create or register a local store'
complete -c openspec -n '__fish_openspec_using_command_path store; and not __fish_openspec_using_command_path store setup; and not __fish_openspec_using_command_path store register; and not __fish_openspec_using_command_path store unregister; and not __fish_openspec_using_command_path store remove; and not __fish_openspec_using_command_path store list; and not __fish_openspec_using_command_path store ls; and not __fish_openspec_using_command_path store doctor' -f -a 'register' -d 'Register an existing store directory'
complete -c openspec -n '__fish_openspec_using_command_path store; and not __fish_openspec_using_command_path store setup; and not __fish_openspec_using_command_path store register; and not __fish_openspec_using_command_path store unregister; and not __fish_openspec_using_command_path store remove; and not __fish_openspec_using_command_path store list; and not __fish_openspec_using_command_path store ls; and not __fish_openspec_using_command_path store doctor' -f -a 'unregister' -d 'Forget a local store registration without deleting files'
complete -c openspec -n '__fish_openspec_using_command_path store; and not __fish_openspec_using_command_path store setup; and not __fish_openspec_using_command_path store register; and not __fish_openspec_using_command_path store unregister; and not __fish_openspec_using_command_path store remove; and not __fish_openspec_using_command_path store list; and not __fish_openspec_using_command_path store ls; and not __fish_openspec_using_command_path store doctor' -f -a 'remove' -d 'Forget a local store registration and delete its local folder'
complete -c openspec -n '__fish_openspec_using_command_path store; and not __fish_openspec_using_command_path store setup; and not __fish_openspec_using_command_path store register; and not __fish_openspec_using_command_path store unregister; and not __fish_openspec_using_command_path store remove; and not __fish_openspec_using_command_path store list; and not __fish_openspec_using_command_path store ls; and not __fish_openspec_using_command_path store doctor' -f -a 'list' -d 'List registered stores'
complete -c openspec -n '__fish_openspec_using_command_path store; and not __fish_openspec_using_command_path store setup; and not __fish_openspec_using_command_path store register; and not __fish_openspec_using_command_path store unregister; and not __fish_openspec_using_command_path store remove; and not __fish_openspec_using_command_path store list; and not __fish_openspec_using_command_path store ls; and not __fish_openspec_using_command_path store doctor' -f -a 'ls' -d 'List registered stores'
complete -c openspec -n '__fish_openspec_using_command_path store; and not __fish_openspec_using_command_path store setup; and not __fish_openspec_using_command_path store register; and not __fish_openspec_using_command_path store unregister; and not __fish_openspec_using_command_path store remove; and not __fish_openspec_using_command_path store list; and not __fish_openspec_using_command_path store ls; and not __fish_openspec_using_command_path store doctor' -f -a 'doctor' -d 'Check local store registration and metadata'

# store setup flags
complete -c openspec -n '__fish_openspec_using_command_path store setup' -f
complete -c openspec -n '__fish_openspec_using_command_path store setup' -l path -r -f -d 'Directory to use for the store'
complete -c openspec -n '__fish_openspec_using_command_path store setup; and __fish_openspec_completing_option_value --path' -l path -r -F -d 'Directory to use for the store'
complete -c openspec -n '__fish_openspec_using_command_path store setup' -l init-git -f -d 'Initialize a Git repository in the store'
complete -c openspec -n '__fish_openspec_using_command_path store setup' -l no-init-git -f -d 'Skip Git repository initialization'
complete -c openspec -n '__fish_openspec_using_command_path store setup' -l remote -r -f -d 'Canonical clone source recorded in store.yaml'
complete -c openspec -n '__fish_openspec_using_command_path store setup' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path store setup; and __fish_openspec_positional_index 0 2 --path --remote' -f
# store register flags
complete -c openspec -n '__fish_openspec_using_command_path store register' -f
complete -c openspec -n '__fish_openspec_using_command_path store register' -l id -r -f -d 'Store id'
complete -c openspec -n '__fish_openspec_using_command_path store register' -l yes -f -d 'Confirm creating store identity metadata'
complete -c openspec -n '__fish_openspec_using_command_path store register' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path store register; and __fish_openspec_positional_index 0 2 --id' -F
# store unregister flags
complete -c openspec -n '__fish_openspec_using_command_path store unregister' -f
complete -c openspec -n '__fish_openspec_using_command_path store unregister' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path store unregister; and __fish_openspec_positional_index 0 2' -f
# store remove flags
complete -c openspec -n '__fish_openspec_using_command_path store remove' -f
complete -c openspec -n '__fish_openspec_using_command_path store remove' -l yes -f -d 'Confirm local store folder deletion'
complete -c openspec -n '__fish_openspec_using_command_path store remove' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path store remove; and __fish_openspec_positional_index 0 2' -f
# store list flags
complete -c openspec -n '__fish_openspec_using_command_path store list' -f
complete -c openspec -n '__fish_openspec_using_command_path store list' -l json -f -d 'Output as JSON'
# store ls flags
complete -c openspec -n '__fish_openspec_using_command_path store ls' -f
complete -c openspec -n '__fish_openspec_using_command_path store ls' -l json -f -d 'Output as JSON'
# store doctor flags
complete -c openspec -n '__fish_openspec_using_command_path store doctor' -f
complete -c openspec -n '__fish_openspec_using_command_path store doctor' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path store doctor; and __fish_openspec_positional_index 0 2' -f

# context flags
complete -c openspec -n '__fish_openspec_using_command_path context' -f
complete -c openspec -n '__fish_openspec_using_command_path context' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path context' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'
complete -c openspec -n '__fish_openspec_using_command_path context' -l code-workspace -r -f -d 'Also write a VS Code workspace file for the set'
complete -c openspec -n '__fish_openspec_using_command_path context; and __fish_openspec_completing_option_value --code-workspace' -l code-workspace -r -F -d 'Also write a VS Code workspace file for the set'
complete -c openspec -n '__fish_openspec_using_command_path context' -l force -f -d 'Overwrite an existing --code-workspace file'

# doctor flags
complete -c openspec -n '__fish_openspec_using_command_path doctor' -f
complete -c openspec -n '__fish_openspec_using_command_path doctor' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path doctor' -l store -r -f -d 'Store id to use as the OpenSpec root (a store is a standalone OpenSpec repo you\'ve registered)'

complete -c openspec -n '__fish_openspec_using_command_path workset; and not __fish_openspec_using_command_path workset create; and not __fish_openspec_using_command_path workset list; and not __fish_openspec_using_command_path workset ls; and not __fish_openspec_using_command_path workset open; and not __fish_openspec_using_command_path workset remove' -f -a 'create' -d 'Compose and save a named working view of folders you choose'
complete -c openspec -n '__fish_openspec_using_command_path workset; and not __fish_openspec_using_command_path workset create; and not __fish_openspec_using_command_path workset list; and not __fish_openspec_using_command_path workset ls; and not __fish_openspec_using_command_path workset open; and not __fish_openspec_using_command_path workset remove' -f -a 'list' -d 'Show saved worksets with their members'
complete -c openspec -n '__fish_openspec_using_command_path workset; and not __fish_openspec_using_command_path workset create; and not __fish_openspec_using_command_path workset list; and not __fish_openspec_using_command_path workset ls; and not __fish_openspec_using_command_path workset open; and not __fish_openspec_using_command_path workset remove' -f -a 'ls' -d 'Show saved worksets with their members'
complete -c openspec -n '__fish_openspec_using_command_path workset; and not __fish_openspec_using_command_path workset create; and not __fish_openspec_using_command_path workset list; and not __fish_openspec_using_command_path workset ls; and not __fish_openspec_using_command_path workset open; and not __fish_openspec_using_command_path workset remove' -f -a 'open' -d 'Open a saved workset in your tool (editor window or agent session)'
complete -c openspec -n '__fish_openspec_using_command_path workset; and not __fish_openspec_using_command_path workset create; and not __fish_openspec_using_command_path workset list; and not __fish_openspec_using_command_path workset ls; and not __fish_openspec_using_command_path workset open; and not __fish_openspec_using_command_path workset remove' -f -a 'remove' -d 'Delete a saved workset (member folders are never touched)'

# workset create flags
complete -c openspec -n '__fish_openspec_using_command_path workset create' -f
complete -c openspec -n '__fish_openspec_using_command_path workset create' -l member -r -f -d 'Member folder as <path> or <name>=<path>; repeatable, first is the primary'
complete -c openspec -n '__fish_openspec_using_command_path workset create; and __fish_openspec_completing_option_value --member' -l member -r -F -d 'Member folder as <path> or <name>=<path>; repeatable, first is the primary'
complete -c openspec -n '__fish_openspec_using_command_path workset create' -l tool -r -f -d 'Preferred tool to open this workset with'
complete -c openspec -n '__fish_openspec_using_command_path workset create' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path workset create; and __fish_openspec_positional_index 0 2 --member --tool' -f
# workset list flags
complete -c openspec -n '__fish_openspec_using_command_path workset list' -f
complete -c openspec -n '__fish_openspec_using_command_path workset list' -l json -f -d 'Output as JSON'
# workset ls flags
complete -c openspec -n '__fish_openspec_using_command_path workset ls' -f
complete -c openspec -n '__fish_openspec_using_command_path workset ls' -l json -f -d 'Output as JSON'
# workset open flags
complete -c openspec -n '__fish_openspec_using_command_path workset open' -f
complete -c openspec -n '__fish_openspec_using_command_path workset open' -l tool -r -f -d 'Open with this tool just this once'
complete -c openspec -n '__fish_openspec_using_command_path workset open; and __fish_openspec_positional_index 0 2 --tool' -f
# workset remove flags
complete -c openspec -n '__fish_openspec_using_command_path workset remove' -f
complete -c openspec -n '__fish_openspec_using_command_path workset remove' -l yes -f -d 'Confirm removal non-interactively'
complete -c openspec -n '__fish_openspec_using_command_path workset remove' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path workset remove; and __fish_openspec_positional_index 0 2' -f

# feedback flags
complete -c openspec -n '__fish_openspec_using_command_path feedback' -f
complete -c openspec -n '__fish_openspec_using_command_path feedback' -l body -r -f -d 'Detailed description for the feedback'
complete -c openspec -n '__fish_openspec_using_command_path feedback; and __fish_openspec_positional_index 0 1 --body' -f

complete -c openspec -n '__fish_openspec_using_command_path change; and not __fish_openspec_using_command_path change show; and not __fish_openspec_using_command_path change list; and not __fish_openspec_using_command_path change validate' -f -a 'show' -d 'Show a change proposal'
complete -c openspec -n '__fish_openspec_using_command_path change; and not __fish_openspec_using_command_path change show; and not __fish_openspec_using_command_path change list; and not __fish_openspec_using_command_path change validate' -f -a 'list' -d 'List all active changes (deprecated)'
complete -c openspec -n '__fish_openspec_using_command_path change; and not __fish_openspec_using_command_path change show; and not __fish_openspec_using_command_path change list; and not __fish_openspec_using_command_path change validate' -f -a 'validate' -d 'Validate a change proposal'

# change show flags
complete -c openspec -n '__fish_openspec_using_command_path change show' -f
complete -c openspec -n '__fish_openspec_using_command_path change show' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path change show' -l deltas-only -f -d 'Show only deltas (JSON only)'
complete -c openspec -n '__fish_openspec_using_command_path change show' -l requirements-only -f -d 'Alias for --deltas-only (deprecated)'
complete -c openspec -n '__fish_openspec_using_command_path change show' -l diff -f -d 'Show per-requirement diffs for delta specs'
complete -c openspec -n '__fish_openspec_using_command_path change show' -l no-interactive -f -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_command_path change show; and __fish_openspec_positional_index 0 2' -a '(__fish_openspec_changes)' -f
# change list flags
complete -c openspec -n '__fish_openspec_using_command_path change list' -f
complete -c openspec -n '__fish_openspec_using_command_path change list' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path change list' -l long -f -d 'Show id and title with counts'
# change validate flags
complete -c openspec -n '__fish_openspec_using_command_path change validate' -f
complete -c openspec -n '__fish_openspec_using_command_path change validate' -l strict -f -d 'Enable strict validation mode'
complete -c openspec -n '__fish_openspec_using_command_path change validate' -l json -f -d 'Output validation results as JSON'
complete -c openspec -n '__fish_openspec_using_command_path change validate' -l no-interactive -f -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_command_path change validate; and __fish_openspec_positional_index 0 2' -a '(__fish_openspec_changes)' -f

complete -c openspec -n '__fish_openspec_using_command_path spec; and not __fish_openspec_using_command_path spec show; and not __fish_openspec_using_command_path spec list; and not __fish_openspec_using_command_path spec validate' -f -a 'show' -d 'Show a specification'
complete -c openspec -n '__fish_openspec_using_command_path spec; and not __fish_openspec_using_command_path spec show; and not __fish_openspec_using_command_path spec list; and not __fish_openspec_using_command_path spec validate' -f -a 'list' -d 'List all specifications'
complete -c openspec -n '__fish_openspec_using_command_path spec; and not __fish_openspec_using_command_path spec show; and not __fish_openspec_using_command_path spec list; and not __fish_openspec_using_command_path spec validate' -f -a 'validate' -d 'Validate a specification'

# spec show flags
complete -c openspec -n '__fish_openspec_using_command_path spec show' -f
complete -c openspec -n '__fish_openspec_using_command_path spec show' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path spec show' -l requirements -f -d 'Show only requirements, exclude scenarios (JSON only)'
complete -c openspec -n '__fish_openspec_using_command_path spec show' -l no-scenarios -f -d 'Exclude scenario content (JSON only)'
complete -c openspec -n '__fish_openspec_using_command_path spec show' -s r -l requirement -r -f -d 'Show specific requirement by ID (JSON only)'
complete -c openspec -n '__fish_openspec_using_command_path spec show' -l no-interactive -f -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_command_path spec show; and __fish_openspec_positional_index 0 2 --requirement -r' -a '(__fish_openspec_specs)' -f
# spec list flags
complete -c openspec -n '__fish_openspec_using_command_path spec list' -f
complete -c openspec -n '__fish_openspec_using_command_path spec list' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path spec list' -l long -f -d 'Show id and title with counts'
# spec validate flags
complete -c openspec -n '__fish_openspec_using_command_path spec validate' -f
complete -c openspec -n '__fish_openspec_using_command_path spec validate' -l strict -f -d 'Enable strict validation mode'
complete -c openspec -n '__fish_openspec_using_command_path spec validate' -l json -f -d 'Output validation results as JSON'
complete -c openspec -n '__fish_openspec_using_command_path spec validate' -l no-interactive -f -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_command_path spec validate; and __fish_openspec_positional_index 0 2' -a '(__fish_openspec_specs)' -f

complete -c openspec -n '__fish_openspec_using_command_path completion; and not __fish_openspec_using_command_path completion generate; and not __fish_openspec_using_command_path completion install; and not __fish_openspec_using_command_path completion uninstall' -f -a 'generate' -d 'Generate completion script for a shell (outputs to stdout)'
complete -c openspec -n '__fish_openspec_using_command_path completion; and not __fish_openspec_using_command_path completion generate; and not __fish_openspec_using_command_path completion install; and not __fish_openspec_using_command_path completion uninstall' -f -a 'install' -d 'Install completion script for a shell'
complete -c openspec -n '__fish_openspec_using_command_path completion; and not __fish_openspec_using_command_path completion generate; and not __fish_openspec_using_command_path completion install; and not __fish_openspec_using_command_path completion uninstall' -f -a 'uninstall' -d 'Uninstall completion script for a shell'

# completion generate flags
complete -c openspec -n '__fish_openspec_using_command_path completion generate' -f
complete -c openspec -n '__fish_openspec_using_command_path completion generate; and __fish_openspec_positional_index 0 2' -a 'zsh bash fish powershell' -f
# completion install flags
complete -c openspec -n '__fish_openspec_using_command_path completion install' -f
complete -c openspec -n '__fish_openspec_using_command_path completion install' -l verbose -f -d 'Show detailed installation output'
complete -c openspec -n '__fish_openspec_using_command_path completion install; and __fish_openspec_positional_index 0 2' -a 'zsh bash fish powershell' -f
# completion uninstall flags
complete -c openspec -n '__fish_openspec_using_command_path completion uninstall' -f
complete -c openspec -n '__fish_openspec_using_command_path completion uninstall' -s y -l yes -f -d 'Skip confirmation prompts'
complete -c openspec -n '__fish_openspec_using_command_path completion uninstall; and __fish_openspec_positional_index 0 2' -a 'zsh bash fish powershell' -f

complete -c openspec -n '__fish_openspec_using_command_path config; and not __fish_openspec_using_command_path config path -- --scope; and not __fish_openspec_using_command_path config list -- --scope; and not __fish_openspec_using_command_path config get -- --scope; and not __fish_openspec_using_command_path config set -- --scope; and not __fish_openspec_using_command_path config unset -- --scope; and not __fish_openspec_using_command_path config reset -- --scope; and not __fish_openspec_using_command_path config edit -- --scope; and not __fish_openspec_using_command_path config profile -- --scope' -f -a 'path' -d 'Show config file location'
complete -c openspec -n '__fish_openspec_using_command_path config; and not __fish_openspec_using_command_path config path -- --scope; and not __fish_openspec_using_command_path config list -- --scope; and not __fish_openspec_using_command_path config get -- --scope; and not __fish_openspec_using_command_path config set -- --scope; and not __fish_openspec_using_command_path config unset -- --scope; and not __fish_openspec_using_command_path config reset -- --scope; and not __fish_openspec_using_command_path config edit -- --scope; and not __fish_openspec_using_command_path config profile -- --scope' -f -a 'list' -d 'Show all current settings'
complete -c openspec -n '__fish_openspec_using_command_path config; and not __fish_openspec_using_command_path config path -- --scope; and not __fish_openspec_using_command_path config list -- --scope; and not __fish_openspec_using_command_path config get -- --scope; and not __fish_openspec_using_command_path config set -- --scope; and not __fish_openspec_using_command_path config unset -- --scope; and not __fish_openspec_using_command_path config reset -- --scope; and not __fish_openspec_using_command_path config edit -- --scope; and not __fish_openspec_using_command_path config profile -- --scope' -f -a 'get' -d 'Get a specific value (raw, scriptable)'
complete -c openspec -n '__fish_openspec_using_command_path config; and not __fish_openspec_using_command_path config path -- --scope; and not __fish_openspec_using_command_path config list -- --scope; and not __fish_openspec_using_command_path config get -- --scope; and not __fish_openspec_using_command_path config set -- --scope; and not __fish_openspec_using_command_path config unset -- --scope; and not __fish_openspec_using_command_path config reset -- --scope; and not __fish_openspec_using_command_path config edit -- --scope; and not __fish_openspec_using_command_path config profile -- --scope' -f -a 'set' -d 'Set a value (auto-coerce types)'
complete -c openspec -n '__fish_openspec_using_command_path config; and not __fish_openspec_using_command_path config path -- --scope; and not __fish_openspec_using_command_path config list -- --scope; and not __fish_openspec_using_command_path config get -- --scope; and not __fish_openspec_using_command_path config set -- --scope; and not __fish_openspec_using_command_path config unset -- --scope; and not __fish_openspec_using_command_path config reset -- --scope; and not __fish_openspec_using_command_path config edit -- --scope; and not __fish_openspec_using_command_path config profile -- --scope' -f -a 'unset' -d 'Remove a key (revert to default)'
complete -c openspec -n '__fish_openspec_using_command_path config; and not __fish_openspec_using_command_path config path -- --scope; and not __fish_openspec_using_command_path config list -- --scope; and not __fish_openspec_using_command_path config get -- --scope; and not __fish_openspec_using_command_path config set -- --scope; and not __fish_openspec_using_command_path config unset -- --scope; and not __fish_openspec_using_command_path config reset -- --scope; and not __fish_openspec_using_command_path config edit -- --scope; and not __fish_openspec_using_command_path config profile -- --scope' -f -a 'reset' -d 'Reset configuration to defaults'
complete -c openspec -n '__fish_openspec_using_command_path config; and not __fish_openspec_using_command_path config path -- --scope; and not __fish_openspec_using_command_path config list -- --scope; and not __fish_openspec_using_command_path config get -- --scope; and not __fish_openspec_using_command_path config set -- --scope; and not __fish_openspec_using_command_path config unset -- --scope; and not __fish_openspec_using_command_path config reset -- --scope; and not __fish_openspec_using_command_path config edit -- --scope; and not __fish_openspec_using_command_path config profile -- --scope' -f -a 'edit' -d 'Open config in $EDITOR'
complete -c openspec -n '__fish_openspec_using_command_path config; and not __fish_openspec_using_command_path config path -- --scope; and not __fish_openspec_using_command_path config list -- --scope; and not __fish_openspec_using_command_path config get -- --scope; and not __fish_openspec_using_command_path config set -- --scope; and not __fish_openspec_using_command_path config unset -- --scope; and not __fish_openspec_using_command_path config reset -- --scope; and not __fish_openspec_using_command_path config edit -- --scope; and not __fish_openspec_using_command_path config profile -- --scope' -f -a 'profile' -d 'Configure workflow profile (interactive picker or preset shortcut)'

complete -c openspec -n '__fish_openspec_using_command_path config' -l scope -r -f -a 'global' -d 'Config scope (only "global" supported currently)'
# config path flags
complete -c openspec -n '__fish_openspec_using_command_path config path -- --scope' -f
# config list flags
complete -c openspec -n '__fish_openspec_using_command_path config list -- --scope' -f
complete -c openspec -n '__fish_openspec_using_command_path config list -- --scope' -l json -f -d 'Output as JSON'
# config get flags
complete -c openspec -n '__fish_openspec_using_command_path config get -- --scope' -f
complete -c openspec -n '__fish_openspec_using_command_path config get -- --scope; and __fish_openspec_positional_index 0 2 --scope' -f
# config set flags
complete -c openspec -n '__fish_openspec_using_command_path config set -- --scope' -f
complete -c openspec -n '__fish_openspec_using_command_path config set -- --scope' -l string -f -d 'Force value to be stored as string'
complete -c openspec -n '__fish_openspec_using_command_path config set -- --scope' -l allow-unknown -f -d 'Allow setting unknown keys'
complete -c openspec -n '__fish_openspec_using_command_path config set -- --scope; and __fish_openspec_positional_index 0 2 --scope' -f
complete -c openspec -n '__fish_openspec_using_command_path config set -- --scope; and __fish_openspec_positional_index 1 2 --scope' -f
# config unset flags
complete -c openspec -n '__fish_openspec_using_command_path config unset -- --scope' -f
complete -c openspec -n '__fish_openspec_using_command_path config unset -- --scope; and __fish_openspec_positional_index 0 2 --scope' -f
# config reset flags
complete -c openspec -n '__fish_openspec_using_command_path config reset -- --scope' -f
complete -c openspec -n '__fish_openspec_using_command_path config reset -- --scope' -l all -f -d 'Reset all configuration (required)'
complete -c openspec -n '__fish_openspec_using_command_path config reset -- --scope' -s y -l yes -f -d 'Skip confirmation prompts'
# config edit flags
complete -c openspec -n '__fish_openspec_using_command_path config edit -- --scope' -f
# config profile flags
complete -c openspec -n '__fish_openspec_using_command_path config profile -- --scope' -f
complete -c openspec -n '__fish_openspec_using_command_path config profile -- --scope; and __fish_openspec_positional_index 0 2 --scope' -f

complete -c openspec -n '__fish_openspec_using_command_path schema; and not __fish_openspec_using_command_path schema which; and not __fish_openspec_using_command_path schema validate; and not __fish_openspec_using_command_path schema fork; and not __fish_openspec_using_command_path schema init' -f -a 'which' -d 'Show where a schema resolves from'
complete -c openspec -n '__fish_openspec_using_command_path schema; and not __fish_openspec_using_command_path schema which; and not __fish_openspec_using_command_path schema validate; and not __fish_openspec_using_command_path schema fork; and not __fish_openspec_using_command_path schema init' -f -a 'validate' -d 'Validate a schema structure and templates'
complete -c openspec -n '__fish_openspec_using_command_path schema; and not __fish_openspec_using_command_path schema which; and not __fish_openspec_using_command_path schema validate; and not __fish_openspec_using_command_path schema fork; and not __fish_openspec_using_command_path schema init' -f -a 'fork' -d 'Copy an existing schema to project for customization'
complete -c openspec -n '__fish_openspec_using_command_path schema; and not __fish_openspec_using_command_path schema which; and not __fish_openspec_using_command_path schema validate; and not __fish_openspec_using_command_path schema fork; and not __fish_openspec_using_command_path schema init' -f -a 'init' -d 'Create a new project-local schema'

# schema which flags
complete -c openspec -n '__fish_openspec_using_command_path schema which' -f
complete -c openspec -n '__fish_openspec_using_command_path schema which' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path schema which' -l all -f -d 'List all schemas with their resolution sources'
complete -c openspec -n '__fish_openspec_using_command_path schema which; and __fish_openspec_positional_index 0 2' -a '(__fish_openspec_schemas)' -f
# schema validate flags
complete -c openspec -n '__fish_openspec_using_command_path schema validate' -f
complete -c openspec -n '__fish_openspec_using_command_path schema validate' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path schema validate' -l verbose -f -d 'Show detailed validation steps'
complete -c openspec -n '__fish_openspec_using_command_path schema validate; and __fish_openspec_positional_index 0 2' -a '(__fish_openspec_schemas)' -f
# schema fork flags
complete -c openspec -n '__fish_openspec_using_command_path schema fork' -f
complete -c openspec -n '__fish_openspec_using_command_path schema fork' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path schema fork' -l force -f -d 'Overwrite existing destination'
complete -c openspec -n '__fish_openspec_using_command_path schema fork; and __fish_openspec_positional_index 0 2' -a '(__fish_openspec_schemas)' -f
complete -c openspec -n '__fish_openspec_using_command_path schema fork; and __fish_openspec_positional_index 1 2' -f
# schema init flags
complete -c openspec -n '__fish_openspec_using_command_path schema init' -f
complete -c openspec -n '__fish_openspec_using_command_path schema init' -l json -f -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_command_path schema init' -l description -r -f -d 'Schema description'
complete -c openspec -n '__fish_openspec_using_command_path schema init' -l artifacts -r -f -d 'Comma-separated artifact IDs'
complete -c openspec -n '__fish_openspec_using_command_path schema init' -l default -f -d 'Set as project default schema'
complete -c openspec -n '__fish_openspec_using_command_path schema init' -l no-default -f -d 'Do not prompt to set as default'
complete -c openspec -n '__fish_openspec_using_command_path schema init' -l force -f -d 'Overwrite existing schema'
complete -c openspec -n '__fish_openspec_using_command_path schema init; and __fish_openspec_positional_index 0 2 --description --artifacts' -f
