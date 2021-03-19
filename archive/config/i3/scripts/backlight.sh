maxBrightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
currentBacklight=$(cat /sys/class/backlight/intel_backlight/brightness)

pace=$((maxBrightness/80))
newValue=0
numericPattern='^[0-9]+$'

if [ "$1" == "" ]; then
  newValue=$(( maxBrightness/2)) # Default Value
elif [ $1 -eq 0 ]; then
  newValue=$pace
elif [ $1 -gt 100 ]; then
  newValue=$maxBrightness
elif [[ "$1" =~ $numericPattern ]]; then
  newValue=$(( (maxBrightness/100) * $1 ))
elif [ $1 == "-" ]; then
  newValue=$(( currentBacklight-pace )) 
fi

echo Old Value: $currentBacklight 
echo New Value: $newValue"/"$maxBrightness

# Set new value
echo $newValue > /sys/class/backlight/intel_backlight/brightness
