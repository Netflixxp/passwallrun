#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="${1:-passwall-full}"
OPENWRT_VERSION="${2:-24.10.6}"
TARGET_NAME="${3:-x86_64}"
IPK_SOURCE_DIR="${4:-./output/ipk}"

WORKDIR="$(pwd)"
BUILD_DIR="${WORKDIR}/output/build-run"
RUN_DIR="${WORKDIR}/output/run"

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}/ipk" "${RUN_DIR}"

cp -av "${IPK_SOURCE_DIR}/"*.ipk "${BUILD_DIR}/ipk/" 2>/dev/null || true
cp -av "${WORKDIR}/scripts/install.sh" "${BUILD_DIR}/install.sh"
chmod +x "${BUILD_DIR}/install.sh"

RUN_NAME="${PACKAGE_NAME}_${OPENWRT_VERSION}_${TARGET_NAME}.run"

makeself \
  --nox11 \
  "${BUILD_DIR}" \
  "${RUN_DIR}/${RUN_NAME}" \
  "${PACKAGE_NAME} for iStoreOS/OpenWrt ${OPENWRT_VERSION} (${TARGET_NAME})" \
  ./install.sh

echo "生成完成：${RUN_DIR}/${RUN_NAME}"
ls -lah "${RUN_DIR}"
