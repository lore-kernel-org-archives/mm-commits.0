From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-sysc-fix-uname26-for-40-fix.patch removed
 from -mm tree
Date: Fri, 27 Feb 2015 15:49:35 -0800
Message-ID: <54f1028f.htr1ciQF+KcB/576%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbbB0Xtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 18:49:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, nuxi@vault24.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-sysc-fix-uname26-for-40-fix
has been removed from the -mm tree.  Its filename was
     kernel-sysc-fix-uname26-for-40-fix.patch

This patch was dropped because it was folded into kernel-sysc-fix-uname26-for-40.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-sysc-fix-uname26-for-40-fix

Cc: Jon DeVree <nuxi@vault24.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sys.c~kernel-sysc-fix-uname26-for-40-fix kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-fix-uname26-for-40-fix
+++ a/kernel/sys.c
@@ -1108,6 +1108,7 @@ DECLARE_RWSEM(uts_sem);
 /*
  * Work around broken programs that cannot handle "Linux 3.0".
  * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
+ * And we map 4.x to 2.6.60+x, so 4.0 would be 2.6.60.
  */
 static int override_release(char __user *release, size_t len)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-sysc-fix-uname26-for-40.patch
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
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
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

