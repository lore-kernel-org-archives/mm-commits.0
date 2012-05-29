From: akpm@linux-foundation.org
Subject: [folded] leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 29 May 2012 14:54:02 -0700
Message-ID: <20120529215402.2E63FA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39785 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2E2VyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:54:03 -0400
Received: by vbnl22 with SMTP id l22so457301vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:54:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, holler@ahsoftware.de, rpurdie@rpsys.net, shuahkhan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-heartbeat-stop-on-shutdown-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch

This patch was dropped because it was folded into leds-heartbeat-stop-on-shutdown.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: leds-heartbeat-stop-on-shutdown-checkpatch-fixes

ERROR: space prohibited after that '!' (ctx:WxW)
#45: FILE: drivers/leds/ledtrig-heartbeat.c:121:
+	if( ! rc )
 	    ^

ERROR: space prohibited after that open parenthesis '('
#45: FILE: drivers/leds/ledtrig-heartbeat.c:121:
+	if( ! rc )

ERROR: space prohibited before that close parenthesis ')'
#45: FILE: drivers/leds/ledtrig-heartbeat.c:121:
+	if( ! rc )

ERROR: space required before the open parenthesis '('
#45: FILE: drivers/leds/ledtrig-heartbeat.c:121:
+	if( ! rc )

total: 4 errors, 0 warnings, 36 lines checked

./patches/leds-heartbeat-stop-on-shutdown.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexander Holler <holler@ahsoftware.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Shuah Khan <shuahkhan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-heartbeat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/ledtrig-heartbeat.c~leds-heartbeat-stop-on-shutdown-checkpatch-fixes drivers/leds/ledtrig-heartbeat.c
--- a/drivers/leds/ledtrig-heartbeat.c~leds-heartbeat-stop-on-shutdown-checkpatch-fixes
+++ a/drivers/leds/ledtrig-heartbeat.c
@@ -122,6 +122,7 @@ static struct notifier_block heartbeat_p
 static int __init heartbeat_trig_init(void)
 {
 	int rc = led_trigger_register(&heartbeat_led_trigger);
+
 	if (!rc) {
 		atomic_notifier_chain_register(&panic_notifier_list,
 					       &heartbeat_panic_nb);
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
leds-heartbeat-stop-on-shutdown.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

