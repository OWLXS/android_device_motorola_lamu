#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# ReSukiSU manager v4.2.0-rc2 (com.resukisu.resukisu), arm64-v8a release from
# https://github.com/ReSukiSU/ReSukiSU/releases. Its signing cert hash is one
# of the ones the kernel driver itself hardcodes and checks against
# (KernelSU/kernel/manager/manager_sign.h, EXPECTED_HASH_RESUKISU), so this
# is just shipping the matching manager app, not what grants root.
#
# Uses the older Android.mk/BUILD_PREBUILT path instead of android_app_import:
# this release apk has compressed JNI libs (Soongs preprocessed: false wants
# that fixed) but is also v2-signed with targetSdkVersion >= 30 (Soongs
# preprocessed: true wants the file left untouched to keep the signature
# valid) - those two android_app_import requirements are mutually exclusive
# for this specific apk. BUILD_PREBUILT does not enforce either check.

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := KernelSU
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := KernelSU.apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_DEX_PREOPT := false
LOCAL_PRODUCT_MODULE := true
LOCAL_ENFORCE_USES_LIBRARIES := false
include $(BUILD_PREBUILT)
