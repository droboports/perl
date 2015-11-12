### PERL5 ###
_build_perl() {
local VERSION="5.22.0"
local FOLDER="perl-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://www.cpan.org/src/5.0/${FILE}"
local XVERSION="1.0.1"
local XFILE="${FOLDER}-cross-${XVERSION}.tar.gz"
local XURL="https://github.com/arsv/perl-cross/releases/download/${XVERSION}/${XFILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
_download_file "${XFILE}" "${XURL}"
tar zvxf "download/${XFILE}" -C "target"
pushd "target/${FOLDER}"
./configure --prefix="${DEST}" --mode=cross --target=arm-linux --target-tools-prefix="${HOST}-" \
  --man1dir="${DEST}/man/man1" --man3dir="${DEST}/man/man3"
make -j1
make -j1 install
popd
}

### INC::LATEST ###
_build_inc_latest() {
local VERSION="0.500"
local FOLDER="inc-latest-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://search.cpan.org/CPAN/authors/id/D/DA/DAGOLDEN/${FILE}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
"${DEST}/bin/perl" Makefile.PL
make
make install
popd
}

### MODULE::BUILD ###
_build_module_build() {
local VERSION="0.4214"
local FOLDER="Module-Build-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://www.cpan.org/authors/id/L/LE/LEONT/${FILE}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
"${DEST}/bin/perl" Makefile.PL
make
make install
popd
}

### BUILD ###
_build() {
  _build_perl
  _build_inc_latest
  _build_module_build
  _package
}
