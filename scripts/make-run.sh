#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="${1:?missing package name}"
OPENWRT_VERSION="${2:?missing openwrt version}"
ARCH_LABEL="${3:?missing arch label}"
PASSWALL_VERSION="${4:?missing passwall version}"
IPK_SOURCE_DIR="${5:?missing ipk source dir}"

WORKDIR="$(pwd)"
BUILD_DIR="${WORKDIR}/output/build-run"
RUN_DIR="${WORKDIR}/output/run"

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}/ipk" "${RUN_DIR}"

shopt -s nullglob
ipk_files=("${IPK_SOURCE_DIR}"/*.ipk)
shopt -u nullglob

if [ ${#ipk_files[@]} -eq 0 ]; then
  echo "ERROR: no .ipk files found in ${IPK_SOURCE_DIR}"
  exit 1
fi

cp -av "${ipk_files[@]}" "${BUILD_DIR}/ipk/"
cp -av "${WORKDIR}/scripts/install.sh" "${BUILD_DIR}/install.sh"
chmod +x "${BUILD_DIR}/install.sh"

RUN_NAME="${PACKAGE_NAME}_${PASSWALL_VERSION}_${OPENWRT_VERSION}_${ARCH_LABEL}.run"

makeself \
  --nox11 \
  "${BUILD_DIR}" \
  "${RUN_DIR}/${RUN_NAME}" \
  "${PACKAGE_NAME} ${PASSWALL_VERSION} for OpenWrt ${OPENWRT_VERSION} (${ARCH_LABEL})" \
  ./install.sh

echo "Generated: ${RUN_DIR}/${RUN_NAME}"
ls -lah "${RUN_DIR}"
