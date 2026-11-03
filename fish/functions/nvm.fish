function nvm -d 'Node Version Manager'
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

function nvm_find_nvmrc -d 'Find nearest .nvmrc'
  bass source ~/.nvm/nvm.sh --no-use ';' nvm_find_nvmrc $argv
end
