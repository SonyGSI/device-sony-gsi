#!/system/bin/sh
#
# Copyright (C) 2020 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# A function to modify a keymaster file to read alternative platform versions
gsi_modify_keymaster_file() {
    local KEYMASTER_FILE=$1
    local SELINUX_CONTEXT="$(ls -Z "${KEYMASTER_FILE}" | cut -d ' ' -f 1 )"
    local MODIFIED_FILE="$(echo "${KEYMASTER_FILE}" | tr / _ | cut -c 2-)"

    cp -a "${KEYMASTER_FILE}" "/gsi/${MODIFIED_FILE}"
    sed -i \
        -e 's/ro.build.version.release/ro.build.noisrev.release/g' \
        -e 's/ro.build.version.security_patch/ro.build.noisrev.security_patch/g' \
        -e 's/ro.product.brand/ro.tcudorp.brand/g' \
        -e 's/ro.product.model/ro.tcudorp.model/g' \
        "/gsi/${MODIFIED_FILE}"
    chcon "${SELINUX_CONTEXT}" "/gsi/${MODIFIED_FILE}"
    mount -o bind "/gsi/${MODIFIED_FILE}" "${KEYMASTER_FILE}"
}

CPU_ABI="$(getprop ro.product.cpu.abi)"
# Set alternative platform versions, tcudorp = product
if [ "${CPU_ABI}" = "armeabi-v7a" ]
then
    setprop ro.tcudorp.brand "Android"
    setprop ro.tcudorp.model 'AOSP on ARM32'
else
    setprop ro.tcudorp.brand "Android"
    setprop ro.tcudorp.model 'AOSP on ARM64'
fi

BOOT_IMAGE=
SLOT_SUFFIX="$(getprop ro.boot.slot_suffix)"
for PARTITION_BLOCK in \
    /dev/block/by-name/boot${SLOT_SUFFIX} \
    /dev/block/by-name/kernel${SLOT_SUFFIX}
do
    if [ -z "${BOOT_IMAGE}" ] && [ -e "${PARTITION_BLOCK}" ]
    then
        BOOT_IMAGE="${PARTITION_BLOCK}"
    fi
done

# Set alternative platform versions, noisrev = version
setprop ro.build.noisrev.release "$(getSPL "${BOOT_IMAGE}" android)"
setprop ro.build.noisrev.security_patch "$(getSPL "${BOOT_IMAGE}" security)"

# Always modify System keymaster to read alternative platform versions
for KEYMASTER in \
    /system/lib/vndk/libsoftkeymasterdevice.so \
    /system/lib/vndk-26/libsoftkeymasterdevice.so \
    /system/lib/vndk-27/libsoftkeymasterdevice.so \
    /system/lib/vndk-28/libsoftkeymasterdevice.so \
    /system/lib/vndk-29/libsoftkeymasterdevice.so \
    /system/lib64/vndk/libsoftkeymasterdevice.so \
    /system/lib64/vndk-26/libsoftkeymasterdevice.so \
    /system/lib64/vndk-27/libsoftkeymasterdevice.so \
    /system/lib64/vndk-28/libsoftkeymasterdevice.so \
    /system/lib64/vndk-29/libsoftkeymasterdevice.so
do
    if [ -f "${KEYMASTER}" ]
    then
        gsi_modify_keymaster_file "${KEYMASTER}"
    fi
done

# Vendor should not need modifications IF the user is using stock Vendor and stock Boot images.
# However for older devices it may be desirable to rebuild the kernel / boot image for security updates.
# Instead of checking, just modify anyway, no hame done.

for KEYMASTER in \
    /vendor/lib/hw/android.hardware.keymaster@3.0-impl-qti.so \
    /vendor/lib64/hw/android.hardware.keymaster@3.0-impl-qti.so
do
    if [ -f "${KEYMASTER}" ]
    then
        gsi_modify_keymaster_file "${KEYMASTER}"
    fi
done

# Restart the Keymaster service to use the modified libraries
if [ "$(getprop init.svc.keymaster-3-0)" = "running" ]
then
    setprop ctl.restart keymaster-3-0
fi
