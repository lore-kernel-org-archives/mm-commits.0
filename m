From: akpm@linux-foundation.org
Subject: + lib-find__bit-reimplementation-fix.patch added to -mm tree
Date: Mon, 23 Feb 2015 16:40:44 -0800
Message-ID: <54ebc88c.0vAGeLs2TF71PGz5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbBXAkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 19:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-find__bit-reimplementation-fix
has been added to the -mm tree.  Its filename is
     lib-find__bit-reimplementation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-find__bit-reimplementation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-find__bit-reimplementation-fix.patch

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
Subject: lib-find__bit-reimplementation-fix

include linux/bitmap.h, per Rasmus

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_last_bit.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/find_last_bit.c~lib-find__bit-reimplementation-fix lib/find_last_bit.c
--- a/lib/find_last_bit.c~lib-find__bit-reimplementation-fix
+++ a/lib/find_last_bit.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-sysc-fix-uname26-for-40-fix.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-find__bit-reimplementation-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

