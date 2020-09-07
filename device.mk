#
# Copyright 2020 The Android Open Source Project
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

# Device path
DEVICE_PATH := device/sony/gsi

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/overlay

# Copy different zygote settings for vendor.img to select by setting property
# ro.zygote=zygote64_32 or ro.zygote=zygote32_64:
#   1. 64-bit primary, 32-bit secondary OR
#   2. 32-bit primary, 64-bit secondary
# init.zygote64_32.rc is in the core_64_bit.mk below
PRODUCT_COPY_FILES += \
    system/core/rootdir/init.zygote32_64.rc:root/init.zygote32_64.rc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.secure_lock_screen.xml:system/etc/permissions/android.software.secure_lock_screen.xml

#USB Audio
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/system/bin/gsi.bluetooth.sh:system/bin/gsi.bluetooth.sh \
    $(DEVICE_PATH)/system/bin/gsi.keymaster.sh:system/bin/gsi.keymaster.sh \
    $(DEVICE_PATH)/system/bin/gsi.props.sh:system/bin/gsi.props.sh \
    $(DEVICE_PATH)/system/bin/gsi.sony.sh:system/bin/gsi.sony.sh

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/system/etc/init/gsi.init.rc:system/etc/init/gsi.init.rc \
    $(DEVICE_PATH)/system/etc/init/gsi.bluetooth.rc:system/etc/init/gsi.bluetooth.rc \
    $(DEVICE_PATH)/system/etc/init/gsi.keymaster.rc:system/etc/init/gsi.keymaster.rc \
    $(DEVICE_PATH)/system/etc/init/gsi.props.rc:system/etc/init/gsi.props.rc \
    $(DEVICE_PATH)/system/etc/init/gsi.sony.rc:system/etc/init/gsi.sony.rc

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/system/usr/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/system/product/media/audio/alarms/Xperia_alarm.ogg:system/product/media/audio/alarms/Xperia_alarm.ogg \
    $(DEVICE_PATH)/system/product/media/audio/notifications/Notification.ogg:system/product/media/audio/notifications/Notification.ogg \
    $(DEVICE_PATH)/system/product/media/audio/notifications/Notification_H.ogg:system/product/media/audio/notifications/Notification_H.ogg \
    $(DEVICE_PATH)/system/product/media/audio/ringtones/Ringer.ogg:system/product/media/audio/ringtones/Ringer.ogg \
    $(DEVICE_PATH)/system/product/media/audio/ringtones/air.ogg:system/product/media/audio/ringtones/air.ogg

PRODUCT_PACKAGES += \
    getSPL

PRODUCT_PACKAGES += \
    Stk

# Android
PRODUCT_PACKAGES += \
    AndroidH8216 \
    AndroidXQAU52

# SystemUI
PRODUCT_PACKAGES += \
    SystemUIXQAU52

# Fingerprint
PRODUCT_PACKAGES += \
    SettingsFingerprintYoshino \
    SettingsFingerprintTama \
    SettingsFingerprintSeine
