# !/usr/bin/env python

import subprocess
import datetime
import json
import re
from html import escape

data = {}

today = datetime.date.today().strftime("%d/%/%Y")

until_date = (datetime.date.today() +
          datetime.timedelta(days=3)).strftime("%d/%m/%Y")

output = subprocess.check_output("khal list now " + until_date + " --notstarted --format '{start-time}-{end-time} {title}'", shell=True)
output = output.decode("utf-8")

next_event_match = re.search("(?<=([0-9][0-9]:[0-9][0-9]-[0-9][0-9]:[0-9][0-9]\s))(.+)", output)

if next_event_match == None:
 data['text'] = "No Next Event" 
else:
 data['text'] = escape(next_event_match.group())

tooltip_output = subprocess.check_output("khal list now " + until_date + " --format '{start-time}-{end-time} {title}'", shell=True)
tooltip_output = tooltip_output.decode("utf-8")
tooltip = escape(tooltip_output)
tooltip = "<big><b>Events</b></big>\n" + re.sub('(.*, \d{2}/\d{2}/\d{4})', '\n<b>\\1</b>', tooltip)

# result = subprocess.run(["agenda", "--print-only"], capture_output=True, text=True)
# tooltip = result.stdout

# tooltip = subprocess.check_output("agenda --print-only", shell=True)

# tooltip = tooltip.decode("utf-8")

data['tooltip'] = tooltip
data['escape'] = True


print(json.dumps(data))

