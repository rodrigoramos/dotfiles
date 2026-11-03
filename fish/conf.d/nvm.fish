## NVMrc Settings
if status is-interactive
  test -z $nvmrc_enable
  and set -g nvmrc_enable "yes"

  test -z $nvmrc_announce
  and set -g nvmrc_announce "yes"
end

function __nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

function __nvm_find_nvmrc
  bass source ~/.nvm/nvm.sh --no-use ';' nvm_find_nvmrc $argv
end

# Apply applyNvmRcUse settings.
function applyNvmRcUse
  # Check for the enable flag and make sure we're running interactive, if not return.
  if test $nvmrc_enable != 'yes'; or not status is-interactive
    return
  end

  # Find nvmrc file location using builtin nvm_find_nvmrc command.
  set -l __nvmrc_file (__nvm_find_nvmrc)

  # Check if nvmrc file not found.
  if test -z $__nvmrc_file
    # No nvmrc file found.
    if test $nvmrc_applied != "N/A"
      # nvmrc was applied, but no nvmrc file found.

      # We know that we will uset the variable.
      set -g nvmrc_applied "N/A"

      useDefaultNVMVersion
      if test "$nvm_use_default_status" = "0"
        return
      end

      # Unload nvm.
      __nvm unload
      set -g nvmrc_node_version "N/A"

      if test $nvmrc_announce = "yes"
        echo "nvmrc: Unloaded nvm."
      end

      return
    end

    if test $nvmrc_node_version = "N/A"
      useDefaultNVMVersion
    end

    return
  end

  # Check if current nvmrc is in use.
  if test $__nvmrc_file = $nvmrc_applied
    # nvmrc file is already applied.
    return
  end

  set -l __nvmrc_node_version (__nvm version (cat $__nvmrc_file))
  # nvmrc file found.
  if test $__nvmrc_node_version = "N/A"
    # nvmrc file specifies a version that nvm does not have installed.
    # Install the version.
    __nvm install

    if test $nvmrc_announce = "yes"
      echo "nvmrc: Installed node version " (cat $__nvmrc_file)
    end
  else if test $__nvmrc_node_version = $nvmrc_node_version
    # nvmrc file specifies the same version that is already in use.
    return
  end

  # Load node version from nvmrc file.
  # If we applied the same version from another nvmrc file, it's not a problem.
  # We will reload the same version.
  __nvm use --silent

  # Set nvmrc_applied to the current nvmrc file.
  set -g nvmrc_applied $__nvmrc_file
  # Set nvmrc_node_version to the current node version.
  set -g nvmrc_node_version (__nvm version)

  if test $nvmrc_announce = "yes"
    echo "nvmrc: Loaded node version $nvmrc_node_version"
  end
end

# Apply default node version, we do not want to install default version.
function useDefaultNVMVersion
  # Try to use default version.
  __nvm use default --silent

  set -g nvm_use_default_status $status
  if test "$nvm_use_default_status" = "0"
    # Default version is set.
    set -g nvmrc_node_version (__nvm version)
    if test $nvmrc_announce = "yes"
      echo "nvmrc: Loaded default node version $nvmrc_node_version"
    end
  end
end

# We need to run applyNvmRcUse on the initialization of each session.
if status is-interactive
  # Set nvmrc_applied to default "N/A" value if not set.
  if test -z $nvmrc_applied
    set -g nvmrc_applied "N/A"
  end

  # Set nvmrc_node_version to default "N/A" value if not set.
  if test -z $nvmrc_node_version
    set -g nvmrc_node_version "N/A"
  end

  applyNvmRcUse
end

# Activates on directory changes.
function __nvmrc --on-variable PWD
  applyNvmRcUse
end
