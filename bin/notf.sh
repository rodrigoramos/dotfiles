#!/bin/bash

print_output() {
 echo {\"text\": \"$percentage\", \"alt\": \"$alt\", \"tooltip\": \"$alt\", \"class\": \"$class\", \"percentage\": $percentage }
}

alt=""
class=""
percentage=0
text=""

# No Value
if [ "$1" = "" ]; then
  print_output
  exit 1
elif [ $1 -eq 1 ]; then
  percentage=50
  alt="Há 1 notificação"
elif [ $1 -gt 1 ]; then
  percentage=50
  alt="Há $1 notificações"
else
  alt="Não há notificações"
fi

print_output

