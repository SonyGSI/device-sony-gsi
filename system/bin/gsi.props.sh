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

copyprop() {
    local value="$(getprop "$2")"
    if [ "$value" ]
    then
        resetprop "$1" "$value"
    fi
}

copyprop ro.product.device ro.product.vendor.device
copyprop ro.product.system.device ro.product.vendor.device

copyprop ro.build.fingerprint ro.vendor.build.fingerprint
copyprop ro.system.build.fingerprint ro.vendor.build.fingerprint
copyprop ro.bootimage.build.fingerprint ro.vendor.build.fingerprint

copyprop ro.product.name ro.product.vendor.name
copyprop ro.product.system.name ro.product.vendor.name

copyprop ro.build.product ro.product.vendor.model
copyprop ro.product.model ro.product.vendor.model
copyprop ro.product.system.model ro.product.vendor.model

copyprop ro.product.manufacturer ro.product.vendor.manufacturer
copyprop ro.system.product.manufacturer ro.product.vendor.manufacturer
