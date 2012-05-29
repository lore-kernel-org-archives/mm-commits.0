From: akpm@linux-foundation.org
Subject: [folded] backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:52:13 -0700
Message-ID: <20120529215213.E9893A037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55008 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2E2VwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:52:15 -0400
Received: by qabg24 with SMTP id g24so295815qab.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:52:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jg1.han@samsung.com, joe@perches.com, kristoffer.ericson@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix
has been removed from the -mm tree.  Its filename was
     backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch

This patch was dropped because it was folded into backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix

use KBUILD_MODNAME, per Joe

Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/jornada720_bl.c  |    2 +-
 drivers/video/backlight/jornada720_lcd.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/jornada720_bl.c~backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -9,7 +9,7 @@
  *
  */
 
-#define pr_fmt(fmt) "jornada720_bl: " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/backlight.h>
 #include <linux/device.h>
diff -puN drivers/video/backlight/jornada720_lcd.c~backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix drivers/video/backlight/jornada720_lcd.c
--- a/drivers/video/backlight/jornada720_lcd.c~backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix
+++ a/drivers/video/backlight/jornada720_lcd.c
@@ -9,7 +9,7 @@
  *
  */
 
-#define pr_fmt(fmt) "jornada720_lcd: " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/device.h>
 #include <linux/fb.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
tmpfs-support-seek_data-and-seek_hole.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-memcg-print-statistics-from-live-counters.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
memcg-decrement-static-keys-at-real-destroy-time.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch
backlight-add-lm3533-backlight-driver.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

