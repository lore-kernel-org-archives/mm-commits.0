From: akpm@linux-foundation.org
Subject: + rtc-add-rtc-driver-for-tps6586x-fix.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:17:45 -0800
Message-ID: <20121221221746.8F33820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50333 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2LUWRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:17:49 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so275675bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:17:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ldewangan@nvidia.com


The patch titled
     Subject: rtc-add-rtc-driver-for-tps6586x-fix
has been added to the -mm tree.  Its filename is
     rtc-add-rtc-driver-for-tps6586x-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
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
cma-use-unsigned-type-for-count-argument-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

