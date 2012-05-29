From: akpm@linux-foundation.org
Subject: [folded] backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:51:14 -0700
Message-ID: <20120529215114.C9ED3A037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62056 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2E2VvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:51:15 -0400
Received: by yenl3 with SMTP id l3so393313yen.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:51:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jg1.han@samsung.com, joe@perches.com, mjg@redhat.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix
has been removed from the -mm tree.  Its filename was
     backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch

This patch was dropped because it was folded into backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix

use KBUILD_MODNAME, per Joe

Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/apple_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/apple_bl.c~backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix drivers/video/backlight/apple_bl.c
--- a/drivers/video/backlight/apple_bl.c~backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix
+++ a/drivers/video/backlight/apple_bl.c
@@ -16,7 +16,7 @@
  *  get at the firmware code in order to figure out what it's actually doing.
  */
 
-#define pr_fmt(fmt) "apple_backlight: " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/kernel.h>
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
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

