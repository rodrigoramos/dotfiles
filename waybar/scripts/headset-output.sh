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
fi

percentage=$1
alt="Battery Level: $percentage%"

if [ $percentage -eq -1 ]; then
  class="charging"
  alt="Charging"
  percentage=0
elif [ $percentage -lt 8 ]; then
  class="critical"
elif [ $percentage -lt 20 ]; then
  class="warning"
fi

print_output
