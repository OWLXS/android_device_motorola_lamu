#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/motorola/lamu/device.mk)

# AxionAOSP identity. Must precede the common inherit below: version.mk is
# parsed during it and reads these at that point. Camera props are left unset
# on purpose so VendorSupport probes the real hardware, which differs between
# the g05 and g15 SKUs this tree covers.
AXION_MAINTAINER := TheMoonX
AXION_PROCESSOR := MTK_Helio_G81_Extreme
LINEAGE_BUILDTYPE := UNOFFICIAL
TARGET_EXCLUDES_AUDIOFX := true

# Keeps Vulkan for system processes and the launcher but runs regular apps on
# OpenGL (persist.sys.vk_use_ogl_for_media). Axion enables the same on its
# entry-level Snapdragons; the Mali-G52 r49 driver here struggles with Vulkan
# HWUI too.
TARGET_NEEDS_VULKAN_MEDIA_FIX := true

# version.mk publishes AXION_PROCESSOR as persist.sys.axion_cpu_info, but
# VendorSupport reads persist.sys.axion_processor_info.
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.axion_processor_info=$(AXION_PROCESSOR)

# Drops the LineageOS apps that have equivalents users install themselves,
# and ships Vivi Music in place of Twelve.
PRODUCT_PACKAGES += \
    Debloat \
    ViviMusic \
    ViaBrowser

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_lamu
PRODUCT_DEVICE := lamu
PRODUCT_MANUFACTURER := motorola
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g15

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="lamu_g-user 15 VVTA35.51-137 7eabca release-keys" \
    BuildFingerprint=motorola/lamu_ge/lamu:15/VVTA35.51-153/cebf3c:user/release-keys \
    DeviceProduct=lamu \
    SystemName=lamu_g
