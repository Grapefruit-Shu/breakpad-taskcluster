#!/bin/bash
set -v -e -x

: GECKO_REPOSITORY              ${GECKO_REPOSITORY:=https://hg.mozilla.org/mozilla-central}
: GECKO_HEAD_REV                ${GECKO_HEAD_REV:=default}

wget ${GECKO_REPOSITORY}/raw-file/${GECKO_HEAD_REV}/testing/taskcluster/scripts/minidump_stackwalk.sh
/bin/bash minidump_stackwalk.sh
