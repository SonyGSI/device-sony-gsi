/*
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H

#if !defined(OS_GENERIC)
#ifdef PROPERTY_VALUE_MAX
#define PVAL_MAX_ALREADY_DEFINED
#ifndef __CUTILS_PROPERTIES_H
#undef PROPERTY_VALUE_MAX
#endif
#endif
#include <cutils/properties.h>
#include <string.h>

static inline const char* getBTDefaultName()
{
    char manufacturer[PROPERTY_VALUE_MAX];
    property_get("ro.product.vendor.manufacturer", manufacturer, "");

    char device[PROPERTY_VALUE_MAX];
    property_get("ro.product.vendor.device", device, "");

    // Sony Devices
    if (!strcmp(manufacturer, "Sony")) {

        if (!strcmp(device, "H8216")) {
            return "Sony Xperia XZ2";
        } else if (!strcmp(device, "XQ-AU52")) {
            return "Sony Xperia 10 II";
        } else {
            return "Unknown Sony Device";
        }

    }

    return "Unknown Device";
}

#define BTM_DEF_LOCAL_NAME getBTDefaultName()

#ifndef PVAL_MAX_ALREADY_DEFINED
#undef PROPERTY_VALUE_MAX
#endif

#endif // OS_GENERIC

// VSC spec support
#define BLE_VND_INCLUDED TRUE

#endif
