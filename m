From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 10 Dec 2013 13:11:32 -0800
Message-ID: <52a78384.zdUJ+wgSFkeOP4ju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3LJVLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 16:11:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 13:11:32 -0800


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_display.c |    8 --------
 include/linux/hid-sensor-ids.h       |    3 ---
 2 files changed, 11 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -6589,11 +6589,7 @@ static void hsw_restore_lcpll(struct drm
 
 	/* Make sure we're not on PC8 state before disabling PC8, otherwise
 	 * we'll hang the machine! */
-<<<<<<< HEAD
-	gen6_gt_force_wake_get(dev_priv);
-=======
 	gen6_gt_force_wake_get(dev_priv, FORCEWAKE_ALL);
->>>>>>> linux-next/akpm-base
 
 	if (val & LCPLL_POWER_DOWN_ALLOW) {
 		val &= ~LCPLL_POWER_DOWN_ALLOW;
@@ -6627,11 +6623,7 @@ static void hsw_restore_lcpll(struct drm
 			DRM_ERROR("Switching back to LCPLL failed\n");
 	}
 
-<<<<<<< HEAD
-	gen6_gt_force_wake_put(dev_priv);
-=======
 	gen6_gt_force_wake_put(dev_priv, FORCEWAKE_ALL);
->>>>>>> linux-next/akpm-base
 }
 
 void hsw_enable_pc8_work(struct work_struct *__work)
diff -puN include/linux/hid-sensor-ids.h~linux-next-git-rejects include/linux/hid-sensor-ids.h
--- a/include/linux/hid-sensor-ids.h~linux-next-git-rejects
+++ a/include/linux/hid-sensor-ids.h
@@ -133,11 +133,8 @@
 #define HID_USAGE_SENSOR_PROP_REPORTING_STATE_NO_EVENTS_ENUM		0x00
 #define HID_USAGE_SENSOR_PROP_REPORTING_STATE_ALL_EVENTS_ENUM		0x01
 
-<<<<<<< HEAD
-=======
 /* Per data field properties */
 #define HID_USAGE_SENSOR_DATA_MOD_NONE					0x00
 #define HID_USAGE_SENSOR_DATA_MOD_CHANGE_SENSITIVITY_ABS		0x1000
 
->>>>>>> linux-next/akpm-base
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

