#!/usr/bin/env bash

set -xe

export GITHUB_TOKEN=${INPUT_GITHUB_TOKEN}

repo='DreamArts/insuitex'

pull_request_number=0
case ${GITHUB_EVENT_NAME} in
'check_suite')
  pull_request_number=$(jq '.check_suite.pull_requests[0].number' <"${GITHUB_EVENT_PATH}")
  ;;
'pull_request_review')
  pull_request_number=$(jq '.pull_request.number' <"${GITHUB_EVENT_PATH}")
  ;;
*)
  echo "Failed to parse event. GITHUB_EVENT_NAME=${GITHUB_EVENT_NAME}"
  exit 1
  ;;
esac

echo "pull_request_number=${pull_request_number}"

hub api "repos/${repo}/pulls/${pull_request_number}" | jq
mergeable_state=$(hub api "repos/${repo}/pulls/${pull_request_number}" | jq '.mergeable_state' -r)

if [ "${mergeable_state}" != 'clean' ]; then
  echo "Failed to automerge ${pull_request_number}. mergeable_state=${mergeable_state}"
  exit 1
fi

merge_method='merge'
hub api -X PUT "repos/${repo}/pulls/${pull_request_number}/merge" -F merge_method=${merge_method} | jq
