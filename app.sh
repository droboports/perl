### PERL5 ###
_build_perl() {
local VERSION="5.20.2"
local FOLDER="perl-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://www.cpan.org/src/5.0/${FILE}"
local XVERSION="0.9.6"
local XFILE="${FOLDER}-cross-${XVERSION}.tar.gz"
local XURL="https://github.com/arsv/perl-cross/releases/download/${XVERSION}/${XFILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
_download_file "${XFILE}" "${XURL}"
tar zvxf "download/${XFILE}" -C "target"
pushd "target/${FOLDER}"
./configure --mode=cross --prefix="${DEST}" --man1dir="${DEST}/man/man1" --man3dir="${DEST}/man/man3" --target=arm-linux --target-tools-prefix="${HOST}-"
make -j1
make -j1 install
popd
}

### BUILD ###
_build() {
  _build_perl
  _package
}
