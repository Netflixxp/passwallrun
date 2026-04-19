#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="${1:-passwall-full}"
OPENWRT_VERSION="${2:-24.10.6}"
ARCH_LABEL="${3:-x86_64}"
PASSWALL_VERSION="${4:-unknown}"
IPK_SOURCE_DIR="${5:-./output/ipk}"

WORKDIR="$(pwd)"
BUILD_DIR="${WORKDIR}/output/build-run"
RUN_DIR="${WORKDIR}/output/run"

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}/ipk" "${RUN_DIR}"

cp -av "${IPK_SOURCE_DIR}/"*.ipk "${BUILD_DIR}/ipk/" 2>/dev/null || true
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
