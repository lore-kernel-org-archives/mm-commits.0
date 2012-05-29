From: akpm@linux-foundation.org
Subject: [folded] leds-led-module-for-da9052-53-pmic-v2-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:53:17 -0700
Message-ID: <20120529215318.0BF8CA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42193 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2E2VxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:53:18 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so295889qab.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:53:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ashish.jangam@kpitcummins.com, dchen@diasemi.com, lars@metafoo.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-led-module-for-da9052-53-pmic-v2-fix
has been removed from the -mm tree.  Its filename was
     leds-led-module-for-da9052-53-pmic-v2-fix.patch

This patch was dropped because it was folded into leds-led-module-for-da9052-53-pmic-v2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: leds-led-module-for-da9052-53-pmic-v2-fix

Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-da9052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-da9052.c~leds-led-module-for-da9052-53-pmic-v2-fix drivers/leds/leds-da9052.c
--- a/drivers/leds/leds-da9052.c~leds-led-module-for-da9052-53-pmic-v2-fix
+++ a/drivers/leds/leds-da9052.c
@@ -40,7 +40,7 @@ struct da9052_led {
 	int brightness;
 };
 
-unsigned char led_reg[] = {
+static unsigned char led_reg[] = {
 	DA9052_LED_CONT_4_REG,
 	DA9052_LED_CONT_5_REG,
 };
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
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk.patch
leds-led-module-for-da9052-53-pmic-v2.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

