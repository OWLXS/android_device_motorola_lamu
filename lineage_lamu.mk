#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

TARGET_DISABLE_EPPE := true

# Hardware feature flags
BYPASS_CHARGE_SUPPORTED := false
HBM_SUPPORTED := false
TARGET_TOUCH_BOOST_SUPPORTED := false
TARGET_DOZE_DOUBLE_TAP_PULSE_SUPPORTED := true
TARGET_DOZE_TAP_PULSE_SUPPORTED := false
TARGET_DOZE_PICKUP_PULSE_SUPPORTED := false
TARGET_DOZE_SIDE_FPS_PULSE_SUPPORTED := false
TARGET_NEEDS_VULKAN_MEDIA_FIX := true
TARGET_DISABLES_LIBPERF := true

# Panel is a dual-mode 60/90Hz IPS LCD (confirmed: FrameworkOverlayLamuLite's
# config_defaultPeakRefreshRate=90). Feeds persist.sys.display_refresh_rates_list
# and the frame_rate_category soong config.
TARGET_SUPPORTED_REFRESH_RATES := 60,90
$(call soong_config_set,surfaceflinger,frame_rate_category_high,90)
$(call soong_config_set,surfaceflinger,frame_rate_category_min,60)

# Desativar/Incluir app
TARGET_INCLUDE_AXFX := true
TARGET_EXCLUDES_AUDIOFX := true

PRODUCT_PACKAGES += \
    Debloat

# Enable AxionFx
$(call inherit-product-if-exists, packages/apps/AxionFx/config.mk)

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/motorola/lamu/device.mk)

LINEAGE_BUILDTYPE := UNOFFICIAL

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
