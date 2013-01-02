From: akpm@linux-foundation.org
Subject: + rtc-add-rtc-driver-for-tps6586x-fix2.patch added to -mm tree
Date: Wed, 02 Jan 2013 15:51:02 -0800
Message-ID: <20130102235102.91279820057@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:39666 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3ABXvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 18:51:04 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so1561720yhr.0
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 15:51:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ldewangan@nvidia.com, marvin24@gmx.de


The patch titled
     Subject: rtc-add-rtc-driver-for-tps6586x-fix2
has been added to the -mm tree.  Its filename is
     rtc-add-rtc-driver-for-tps6586x-fix2.patch

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
Subject: rtc-add-rtc-driver-for-tps6586x-fix2

start epoch in 2009

Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Marc Dietrich <marvin24@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps6586x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-add-rtc-driver-for-tps6586x-fix2 drivers/rtc/Kconfig
diff -puN drivers/rtc/Makefile~rtc-add-rtc-driver-for-tps6586x-fix2 drivers/rtc/Makefile
diff -puN drivers/rtc/rtc-tps6586x.c~rtc-add-rtc-driver-for-tps6586x-fix2 drivers/rtc/rtc-tps6586x.c
--- a/drivers/rtc/rtc-tps6586x.c~rtc-add-rtc-driver-for-tps6586x-fix2
+++ a/drivers/rtc/rtc-tps6586x.c
@@ -260,8 +260,8 @@ static int tps6586x_rtc_probe(struct pla
 	rtc->dev = &pdev->dev;
 	rtc->irq = platform_get_irq(pdev, 0);
 
-	/* Set epoch start as 00:00:00:01:01:2000 */
-	rtc->epoch_start = mktime(2000, 1, 1, 0, 0, 0);
+	/* Set epoch start as 00:00:00:01:01:2009 */
+	rtc->epoch_start = mktime(2009, 1, 1, 0, 0, 0);
 
 	/* 1 kHz tick mode, enable tick counting */
 	ret = tps6586x_update(tps_dev, RTC_CTRL,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
rtc-add-rtc-driver-for-tps6586x-fix2.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
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
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

