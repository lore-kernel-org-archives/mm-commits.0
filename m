From: akpm@linux-foundation.org
Subject: + arch-x86-platform-ce4100-ce4100c-include-rebooth.patch added to -mm tree
Date: Mon, 15 Jul 2013 16:11:25 -0700
Message-ID: <51e4819d.wvnXJ1EnZVFfFB35%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab3GOXL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Jul 2013 19:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, fengguang.wu@intel.com, akpm@linux-foundation.org

Subject: + arch-x86-platform-ce4100-ce4100c-include-rebooth.patch added to -mm tree
To: akpm@linux-foundation.org,fengguang.wu@intel.com,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 15 Jul 2013 16:11:25 -0700


The patch titled
     Subject: arch/x86/platform/ce4100/ce4100.c: include reboot.h
has been added to the -mm tree.  Its filename is
     arch-x86-platform-ce4100-ce4100c-include-rebooth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-platform-ce4100-ce4100c-include-rebooth.patch

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
Subject: arch/x86/platform/ce4100/ce4100.c: include reboot.h

arch/x86/platform/ce4100/ce4100.c: In function 'x86_ce4100_early_setup':
arch/x86/platform/ce4100/ce4100.c:165:2: error: 'reboot_type' undeclared (first use in this function)

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/ce4100/ce4100.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/platform/ce4100/ce4100.c~arch-x86-platform-ce4100-ce4100c-include-rebooth arch/x86/platform/ce4100/ce4100.c
--- a/arch/x86/platform/ce4100/ce4100.c~arch-x86-platform-ce4100-ce4100c-include-rebooth
+++ a/arch/x86/platform/ce4100/ce4100.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/reboot.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

