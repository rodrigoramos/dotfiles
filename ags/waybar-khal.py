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

output = subprocess.check_output(["/usr/bin/khal", "-c", "/home/rodrigosilva/.config/khal/config", "list", "now", until_date, "--format", "- \"startDate\": \"{start-date-long}\", \"endDate\": \"{end-date-long}\", \"startTime\": \"{start-time}\", \"endTime\": \"{end-time}\", \"title\": \"{title}\" -"])
output = output.decode("utf-8")

events = re.findall("-(.*)-\n", output)

print("[{" + "},{".join(events) + "}]")
