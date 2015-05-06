From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
 added to -mm tree
Date: Wed, 06 May 2015 12:50:49 -0700
Message-ID: <554a7099.6DN/xAK8j06RbcST%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbbEFTuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 15:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, gregory.clement@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-armada38x.c: remove unused local `flags'
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch

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
Subject: drivers/rtc/rtc-armada38x.c: remove unused local `flags'

Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-armada38x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-armada38x.c~drivers-rtc-rtc-armada38xc-remove-unused-local-flags drivers/rtc/rtc-armada38x.c
--- a/drivers/rtc/rtc-armada38x.c~drivers-rtc-rtc-armada38xc-remove-unused-local-flags
+++ a/drivers/rtc/rtc-armada38x.c
@@ -64,7 +64,7 @@ static void rtc_delayed_write(u32 val, s
 static int armada38x_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct armada38x_rtc *rtc = dev_get_drvdata(dev);
-	unsigned long time, time_check, flags;
+	unsigned long time, time_check;
 
 	mutex_lock(&rtc->mutex_time);
 	time = readl(rtc->regs + RTC_TIME);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch

