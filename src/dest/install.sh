#!/usr/bin/env sh

prog_dir="$(dirname "$(realpath "${0}")")"
name="$(basename "${prog_dir}")"
log_dir="/tmp/DroboApps/${log_dir}"
logfile="${log_dir}/install.log"

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

# copy default configuration files
find "${prog_dir}" -type f -name "*.default" -print | while read deffile; do
  basefile="$(dirname "${deffile}")/$(basename "${deffile}" .default)"
  if [ ! -f "${basefile}" ]; then
    cp -vf "${deffile}" "${basefile}"
  fi
done

# symlink /usr/bin/perl
if [ ! -e "/usr/bin/perl" ]; then
  ln -s "${prog_dir}/bin/perl" "/usr/bin/perl"
elif [ -h "/usr/bin/perl" ] && [ "$(readlink /usr/bin/perl)" != "${prog_dir}/bin/perl" ]; then
  ln -fs "${prog_dir}/bin/perl" "/usr/bin/perl"
fi
