From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-rtc-driver-for-tps6586x-fix.patch removed from -mm tree
Date: Fri, 04 Jan 2013 15:20:25 -0800
Message-ID: <20130104232026.94F2620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59021 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab3ADXU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jan 2013 18:20:29 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so1059051wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 04 Jan 2013 15:20:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ldewangan@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-rtc-driver-for-tps6586x-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-rtc-driver-for-tps6586x-fix.patch

This patch was dropped because it was folded into rtc-add-rtc-driver-for-tps6586x.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-rtc-driver-for-tps6586x-fix

remove stray semicolons

Cc: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps6586x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-tps6586x.c~rtc-add-rtc-driver-for-tps6586x-fix drivers/rtc/rtc-tps6586x.c
--- a/drivers/rtc/rtc-tps6586x.c~rtc-add-rtc-driver-for-tps6586x-fix
+++ a/drivers/rtc/rtc-tps6586x.c
@@ -323,7 +323,7 @@ static int tps6586x_rtc_suspend(struct d
 	if (device_may_wakeup(dev))
 		enable_irq_wake(rtc->irq);
 	return 0;
-};
+}
 
 static int tps6586x_rtc_resume(struct device *dev)
 {
@@ -332,7 +332,7 @@ static int tps6586x_rtc_resume(struct de
 	if (device_may_wakeup(dev))
 		disable_irq_wake(rtc->irq);
 	return 0;
-};
+}
 #endif
 
 static const struct dev_pm_ops tps6586x_pm_ops = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x.patch
rtc-add-rtc-driver-for-tps6586x-fix2.patch
linux-next.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
kernel-auditc-avoid-negative-sleep-durations.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

