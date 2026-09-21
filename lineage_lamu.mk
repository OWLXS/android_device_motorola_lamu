#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

TARGET_DISABLE_EPPE := true

# Identity variables for Axion
AXION_MAINTAINER := TheMoonX_-
AXION_PROCESSOR := MediaTek_Helio_G81_Extreme
AXION_CAMERA_REAR_INFO := 50,2
AXION_CAMERA_FRONT_INFO := 8

# Hardware feature flags for Axion
BYPASS_CHARGE_SUPPORTED := false
HBM_SUPPORTED := false
TARGET_TOUCH_BOOST_SUPPORTED := false
TARGET_DOZE_DOUBLE_TAP_PULSE_SUPPORTED := true
TARGET_DOZE_TAP_PULSE_SUPPORTED := false
TARGET_DOZE_PICKUP_PULSE_SUPPORTED := false
TARGET_DOZE_SIDE_FPS_PULSE_SUPPORTED := false
TARGET_NEEDS_VULKAN_MEDIA_FIX := true
TARGET_DISABLES_LIBPERF := true

# Desativar/Incluir app
TARGET_INCLUDE_AXFX := true
TARGET_EXCLUDES_AUDIOFX := true

PRODUCT_PACKAGES += \
    Debloat

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/motorola/lamu/device.mk)

# version.mk publishes AXION_PROCESSOR as persist.sys.axion_cpu_info, but
# VendorSupport reads persist.sys.axion_processor_info.
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.axion_processor_info=$(AXION_PROCESSOR)

# Inherit Axion common defaults
$(call inherit-product, device/axion/common/config/defaults_common.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_lamu
PRODUCT_DEVICE := lamu
PRODUCT_MANUFACTURER := motorola
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g15

PRODUCT_GMS_CLIENTID_BASE := android-motorola

# Renderer & Performance Overrides
PRODUCT_PRODUCT_PROPERTIES += \
    debug.sf.latch_unsignaled=0 \
    debug.sf.enable_gl_backpressure=1 \
    renderthread.skia.reduceopstask_runtime=true \
    debug.sf.enable_hwc_vds=0 \
    ro.surface_flinger.has_wide_color_display=false \
    ro.surface_flinger.has_HDR_display=false \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
    dalvik.vm.dex2oat-threads=6 \
    dalvik.vm.image-dex2oat-threads=6

# Custom Apps (Jelly/AudioFX already excluded via Debloat LOCAL_OVERRIDES_PACKAGES
# and TARGET_EXCLUDES_AUDIOFX above)
PRODUCT_PACKAGES += \
    ViaBrowser \
    ViviMusic

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="lamu_g-user 15 VVTA35.51-137 7eabca release-keys" \
    BuildFingerprint=motorola/lamu_ge/lamu:15/VVTA35.51-153/cebf3c:user/release-keys \
    DeviceProduct=lamu \
    SystemName=lamu_g
