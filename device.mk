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

# OTA updater: lamu isn't an AxionAOSP official device, so the app's
# hardcoded default (raw.githubusercontent.com/AxionAOSP/official_devices)
# never has an entry for it and the Updater app always shows "up to date".
# lineage.updater.uri (Updater/.../Constants.PROP_UPDATER_URI) overrides
# that default; {device}/{variant} get substituted by the app itself
# (Utils.getServerURL()). Manifests published manually to OWLXS/ota, only
# after a build is tested on device - see that repo's README.
PRODUCT_PRODUCT_PROPERTIES += \
    lineage.updater.uri=https://raw.githubusercontent.com/OWLXS/ota/main/{variant}/{device}.json

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

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# lmkd tuning
# - swap_compression_ratio/relaxed_available_memory: lmkd's "how much room is
#   really left" math assumes 1:1 (no compression) by default, which
#   underestimates available memory on a zram-swap device and can kill apps
#   earlier than necessary. Originally 3, matching lz4's measured ratio
#   (~3.16x from /sys/block/zram0/mm_stat), rounded down to stay
#   conservative.
#   Remeasured after the zstd switch (init.mt6768.rc comp_algorithm) under
#   real mixed-app memory pressure (YouTube + PiP + background app, see
#   19/09 session): mm_stat gave 5.34x (orig_data_size/compr_data_size),
#   consistent with the 5.21x seen earlier in AxDiagnostics. Bumped 3 -> 5,
#   rounded down the same conservative way. Note the direction: a higher
#   ratio makes lmkd MORE lenient (it believes swap buys back more real
#   memory), so this trades a bit more tolerance for background apps
#   ballooning into swap in exchange for fewer app kills/restarts - keep
#   that in mind if a future device still feels laggy under heavy
#   multitasking despite this being accurate; the fix there is a
#   different knob (e.g. vm.swappiness), not this ratio.
# - kill_heaviest_task: among equally-eligible kill candidates, kill the one
#   using the most memory so each kill relieves more pressure - fewer kills
#   needed for the same relief.
# - psi_partial_stall_ms/thrashing_limit/thrashing_limit_decay: the same
#   "patient about brief blips, quick to react to real thrashing" balance
#   ro.config.low_ram uses, applied directly. Deliberately not setting
#   ro.config.low_ram itself - that flag also cuts unrelated framework
#   limits (e.g. ActiveServices' concurrent background services 8->1,
#   several BroadcastConstants queue limits roughly in half), which would
#   work against multitasking rather than for it.
# - direct_reclaim_threshold_ms: flags a specific, well-documented jank
#   cause (an app thread synchronously blocked in kernel direct reclaim)
#   as its own kill signal, on top of the general PSI averages. Requires
#   the bpfMemEvents BPF program (added to PRODUCT_PACKAGES below) or lmkd
#   silently disables it at runtime.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.lmk.swap_compression_ratio=5 \
    ro.lmk.relaxed_available_memory=true \
    ro.lmk.kill_heaviest_task=true \
    ro.lmk.psi_partial_stall_ms=200 \
    ro.lmk.thrashing_limit=20 \
    ro.lmk.thrashing_limit_decay=60 \
    ro.lmk.direct_reclaim_threshold_ms=50

PRODUCT_PACKAGES += \
    bpfMemEvents.bpf

# SPL
BOOT_SECURITY_PATCH := 2026-04-05
INIT_BOOT_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# Inherit from common tree
$(call inherit-product, device/motorola/mt6768-common/mt6768.mk)

# Inherit the proprietary files
$(call inherit-product, vendor/motorola/lamu/lamu-vendor.mk)
