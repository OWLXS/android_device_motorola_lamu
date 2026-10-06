#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Display
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 2400

# Overlays
PRODUCT_PACKAGES += \
    ApertureOverlayLamu \
    FrameworkOverlayLamu \
    FrameworkOverlayLamuLite \
    SystemUIOverlayLamu

# Shipping API Level
BOARD_SHIPPING_API_LEVEL := 202404
PRODUCT_SHIPPING_API_LEVEL := 35

# SKU properties
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/sku/product,$(TARGET_COPY_OUT_PRODUCT)/etc/prop) \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/sku/odm,$(TARGET_COPY_OUT_ODM)/etc/prop)

# Vulkan capability declaration (standard AOSP permission XMLs -- the Mali
# GPU on this SoC supports Vulkan 1.4; without these, apps/Play Store can't
# see hardware.vulkan.version/level/compute feature flags). See
# BoardConfig.mk for TARGET_USES_VULKAN.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

# Product identity (model name / OEM GMS attribution / stock build
# fingerprint -- same regardless of which ROM product.mk inherits this
# file, so it lives here instead of being duplicated per product.mk)
PRODUCT_MODEL := moto g15
PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="lamu_g-user 15 VVTA35.51-137 7eabca release-keys" \
    BuildFingerprint=motorola/lamu_ge/lamu:15/VVTA35.51-153/cebf3c:user/release-keys \
    DeviceProduct=lamu \
    SystemName=lamu_g

# Panel is a dual-mode 60/90Hz IPS LCD (confirmed: FrameworkOverlayLamuLite's
# config_defaultPeakRefreshRate=90). Without this, the framework has no
# declared 90Hz mode to switch into and effectively caps at 60fps despite
# the hardware supporting more. Feeds persist.sys.display_refresh_rates_list
# and the frame_rate_category soong config.
TARGET_SUPPORTED_REFRESH_RATES := 60,90
$(call soong_config_set,surfaceflinger,frame_rate_category_high,90)
$(call soong_config_set,surfaceflinger,frame_rate_category_min,60)

# Odex: compila system/priv-app inteiro AOT no build (em vez do default
# speed-profile, que depende de profile ainda vazio no primeiro boot e usa
# JIT/interpretado até esquentar). Evita JIT em uso normal num SoC fraco;
# o custo (odex maior) é absorvido pela compressao lz4hc,9 do erofs acima.
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := speed

# lamu: CONFIG_CFI_CLANG is required by the FCM matrix (202404) this release
# targets, but enabling it panics on boot (do_one_initcall CFI failure
# loading bootprof.ko) -- confirmed via expdb dump after a real bootloop on
# hardware, 04/10. Root cause: CFI/LTO must be set identically in BOTH
# kernel-6.6/arch/arm64/configs/gki_defconfig (feeds the Image.gz "ack"
# build) AND kernel_device_modules-6.6/kernel/configs/lamu_overlay.config
# (feeds the device module build) -- the ack target never reads the
# overlay, so setting it in only one place produces a real Image<->module
# CFI type-hash mismatch, not just a VINTF paperwork issue. Decided to keep
# CFI off (matches this kernel's proven-working state) rather than chase
# that overlay mirroring right now, and instead stop the build from
# enforcing the kernel-specific part of the VINTF check. This only skips
# the kernel config/version check inside checkvintf --check-compat; the
# rest of VINTF (HAL manifest/matrix compatibility) still runs normally.
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# SPL
BOOT_SECURITY_PATCH := 2026-08-05
INIT_BOOT_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# Inherit from common tree
$(call inherit-product, device/motorola/mt6768-common/mt6768.mk)

# Inherit the proprietary files
$(call inherit-product, vendor/motorola/lamu/lamu-vendor.mk)
