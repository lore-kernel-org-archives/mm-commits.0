From: akpm@linux-foundation.org
Subject: [folded] backlight-add-lm3533-backlight-driver-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:49:52 -0700
Message-ID: <20120529214952.F419CA037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50336 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2E2Vty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:49:54 -0400
Received: by vbnl22 with SMTP id l22so456381vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:49:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org, jhovold@gmail.com, jic23@cam.ac.uk, rob@landley.net, rpurdie@rpsys.net, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-lm3533-backlight-driver-fix
has been removed from the -mm tree.  Its filename was
     backlight-add-lm3533-backlight-driver-fix.patch

This patch was dropped because it was folded into backlight-add-lm3533-backlight-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-lm3533-backlight-driver-fix

fix warning

drivers/video/backlight/lm3533_bl.c:256: warning: initialization from incompatible pointer type

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <jhovold@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Landley <rob@landley.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3533_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lm3533_bl.c~backlight-add-lm3533-backlight-driver-fix drivers/video/backlight/lm3533_bl.c
--- a/drivers/video/backlight/lm3533_bl.c~backlight-add-lm3533-backlight-driver-fix
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -237,7 +237,7 @@ static struct attribute *lm3533_bl_attri
 	NULL,
 };
 
-static mode_t lm3533_bl_attr_is_visible(struct kobject *kobj,
+static umode_t lm3533_bl_attr_is_visible(struct kobject *kobj,
 					     struct attribute *attr, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
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
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
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

