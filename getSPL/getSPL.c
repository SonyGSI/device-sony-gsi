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

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
    if(argc!=3) {
        fprintf(stderr, "Usage: %s <bootimg> <android|security>\n", argv[0]);
        exit(-1);
    }

    // Open the boot image and seek to the platform version metadata
    int bootimage = open(argv[1], O_RDONLY);
    lseek(bootimage, 11*4, SEEK_SET);

    // Get the platform versions
    uint32_t platform = 0;
    read(bootimage, &platform, sizeof(platform));

    // Get the Android version
    int android = platform >> 11;
    int major = android >> 14;
    int minor = (android >> 7) & 0x7f;
    int patch = android & 0x7f;

    // Get the Security patch
    int security = platform & 0x7ff;
    int year = 2000 + (security >> 4);
    int month = security & 0xf;

    if (!strcmp(argv[2], "android")) {
        fprintf(stderr, "Android: %d.%d.%d\n", major, minor, patch);
        printf("%d.%d.%d", major, minor, patch);
    } else if (!strcmp(argv[2], "security")) {
        fprintf(stderr, "Security: %04d-%02d-%02d\n", year, month, 1);
        printf("%04d-%02d-%02d", year, month, 1);
    }

    return 0;
}
