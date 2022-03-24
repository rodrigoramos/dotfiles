#!/usr/bin/env python

import subprocess
import datetime
import json
import re
from html import escape

data = {}

today = datetime.date.today().strftime("%d/%/%Y")

until_date = (datetime.date.today() +
             datetime.timedelta(days=4)).strftime("%d/%m/%Y")

output = subprocess.check_output("khal list now " + until_date + " --format '{start-time}-{end-time} {title}'", shell=True)
output = output.decode("utf-8")

next_event_match = re.search("[0-9][0-9]:[0-9][0-9]-[0-9][0-9].+", output)

if next_event_match == None:
    data['text'] = ""
else:
    data['text'] = " " + next_event_match.group()

data['tooltip'] = output

print(json.dumps(data))
