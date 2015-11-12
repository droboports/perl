#!/usr/bin/env sh
#
# Service.sh for perl5

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="perl5"
version="5.22.0"
description="Perl 5 programming language environment"
depends=""
webui=""

prog_dir="$(dirname "$(realpath "${0}")")"
exec_files="perl"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  framework_version="2.0"
  . "${prog_dir}/libexec/service.subr"
fi

# symlink exec_files
_symlink_exec_files() {
  for exec_file in ${exec_files}; do
    if [ ! -e "/usr/bin/${exec_file}" ]; then
      ln -fs "${prog_dir}/bin/${exec_file}" "/usr/bin/${exec_file}"
    elif [ -h "/usr/bin/${exec_file}" ] && [ "$(readlink /usr/bin/${exec_file})" != "${prog_dir}/bin/${exec_file}" ]; then
      ln -fs "${prog_dir}/bin/${exec_file}" "/usr/bin/${exec_file}"
    fi
  done
}

start() {
  _symlink_exec_files
  rm -f "${errorfile}"
  echo "Perl 5 is configured." > "${statusfile}"
  touch "${pidfile}"
  return 0
}

is_running() {
  [ -f "${pidfile}" ]
}

stop() {
  rm -f "${pidfile}"
  return 0
}

force_stop() {
  rm -f "${pidfile}"
  return 0
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

main "${@}"
