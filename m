From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-da9055c-fix-cross-section-reference.patch added to -mm tree
Date: Fri, 04 Jan 2013 15:43:14 -0800
Message-ID: <20130104234315.0606320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:42433 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab3ADXnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jan 2013 18:43:17 -0500
Received: by mail-la0-f73.google.com with SMTP id fq13so469080lab.2
        for <mm-commits@vger.kernel.org>; Fri, 04 Jan 2013 15:43:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: drivers/rtc/rtc-da9055.c: fix cross-section reference
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-da9055c-fix-cross-section-reference.patch

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
Subject: drivers/rtc/rtc-da9055.c: fix cross-section reference

WARNING: drivers/rtc/rtc-da9055.o(.text+0xa71): Section mismatch in reference from the function da9055_rtc_probe() to the function .init.text:da9055_rtc_device_init()




Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9055.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-da9055.c~drivers-rtc-rtc-da9055c-fix-cross-section-reference drivers/rtc/rtc-da9055.c
--- a/drivers/rtc/rtc-da9055.c~drivers-rtc-rtc-da9055c-fix-cross-section-reference
+++ a/drivers/rtc/rtc-da9055.c
@@ -227,7 +227,7 @@ static const struct rtc_class_ops da9055
 	.alarm_irq_enable = da9055_rtc_alarm_irq_enable,
 };
 
-static int __init da9055_rtc_device_init(struct da9055 *da9055,
+static int da9055_rtc_device_init(struct da9055 *da9055,
 					struct da9055_pdata *pdata)
 {
 	int ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x.patch
linux-next.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
drivers-rtc-rtc-da9055c-fix-cross-section-reference.patch
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
aio-dont-include-aioh-in-schedh-fix-3.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

