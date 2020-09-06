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


VENDOR_DEVICE=$(getprop ro.product.vendor.device)

case ${VENDOR_DEVICE} in

    # Sony Xperia XZ1
    G8341 | G8342 )
        setprop ro.product.platform "yoshino"
        ;;

    # Sony Xperia XZ2
    H8216 | H8266 | H8296 )
        setprop ro.product.platform "tama"
        ;;

    # Sony Xperia 10 II
    XQ-AU51 | XQ-AU52 )
        setprop ro.product.platform "seine"
        ;;

    # Unknown
    *)
        echo "Unknown Sony device, initialization may be incomplete!"
        ;;
esac
