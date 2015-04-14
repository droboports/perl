#!/usr/bin/env sh

prog_dir="$(dirname "$(realpath "${0}")")"
name="$(basename "${prog_dir}")"
log_dir="/tmp/DroboApps/${log_dir}"
logfile="${log_dir}/uninstall.log"

# ensure log folder exists
if [ ! -d "${log_dir}" ]; then mkdir -p "${log_dir}"; fi
# redirect all output to logfile
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
# log current date, time, and invocation parameters
echo $(date +"%Y-%m-%d %H-%M-%S"): ${0} ${@}

# script hardening
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o pipefail # propagate last error code on pipe
set -o xtrace   # enable script tracing

if [ -h "/usr/bin/perl" ] && [ "$(readlink /usr/bin/perl)" = "${prog_dir}/bin/perl" ]; then
  rm -f "/usr/bin/perl"
fi
