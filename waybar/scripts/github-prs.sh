#!/bin/bash

print_output() {
 echo -e {\"text\": \"$text\", \"escape\": false, \"alt\": \"$alt\", \"tooltip\": \"$tooltip\", \"class\": \"$class\" }
}

alt=""
class=""
text=""
tooltip=""

github_status_output="$(gh status)"
pr_review_requests_count=$(echo $github_status_output | grep -cE PRAVALER\/\[^#\]+#\[0-9\]\{1,4\}\[^│]+)

if [ "$pr_review_requests_count" == "0" ]; then
  pr_review_requests="It's all good ^_^"
  alt="nothingtodo"
else
  # pr_review_requests="$(echo $github_status_output | grep -oE PRAVALER\/\[^#\]+#\[0-9\]\{1,4\}\[^│]+)"
  pr_review_requests="$(echo $github_status_output | grep -oE PRAVALER\/\[^#\]+#\[0-9\]\{1,4\}\[^│]+ | sed 's/\(PRAVALER\/[^#]\+#[0-9]\+\)\s\+\(.*$\)/\r\1 <b>\2<\/b>/')"
  alt="pending"
fi

text=$pr_review_requests_count
tooltip="<i>Review Requests</i>\r"$pr_review_requests

print_output
