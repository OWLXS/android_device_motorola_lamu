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

# Disable the secure_element HAL on no-NFC SKUs (see init.lamu.nfc.rc)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.lamu.nfc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.lamu.nfc.rc

# Select BFQ as the storage I/O scheduler (see init.lamu.storage.rc)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.lamu.storage.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.lamu.storage.rc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# SPL
BOOT_SECURITY_PATCH := 2026-04-05
INIT_BOOT_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# Inherit from common tree
$(call inherit-product, device/motorola/mt6768-common/mt6768.mk)

# Inherit the proprietary files
$(call inherit-product, vendor/motorola/lamu/lamu-vendor.mk)
