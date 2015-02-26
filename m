From: akpm@linux-foundation.org
Subject: + binfmt_misc-simplify-entry_status-fix.patch added to -mm tree
Date: Thu, 26 Feb 2015 15:18:02 -0800
Message-ID: <54efa9aa.pbx4Bi3KUd7AyicZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbbBZXSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 18:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc-simplify-entry_status-fix
has been added to the -mm tree.  Its filename is
     binfmt_misc-simplify-entry_status-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_misc-simplify-entry_status-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_misc-simplify-entry_status-fix.patch

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
Subject: binfmt_misc-simplify-entry_status-fix

it's odd to include kernel.h after everything else

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-simplify-entry_status-fix fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-simplify-entry_status-fix
+++ a/fs/binfmt_misc.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -24,7 +25,6 @@
 #include <linux/syscalls.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
-#include <linux/kernel.h>
 
 #ifdef DEBUG
 # define USE_DEBUG 1
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
mips-rename-brk_rnd-to-mmap_rnd.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

