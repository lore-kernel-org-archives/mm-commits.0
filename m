From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Mon, 02 Mar 2015 11:09:13 -0800
Message-ID: <54f4b559.LmziqZjial3C8cbs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbbCBTJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 14:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN arch/s390/include/asm/pgtable.h~linux-next-rejects arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~linux-next-rejects
+++ a/arch/s390/include/asm/pgtable.h
@@ -84,15 +84,8 @@ extern unsigned long zero_page_mask;
  * that leads to 1024 pte per pgd
  */
 #define PTRS_PER_PTE	256
-#ifndef CONFIG_64BIT
-#define __PAGETABLE_PUD_FOLDED
-#define PTRS_PER_PMD	1
-#define __PAGETABLE_PMD_FOLDED
-#define PTRS_PER_PUD	1
-#else /* CONFIG_64BIT */
 #define PTRS_PER_PMD	2048
 #define PTRS_PER_PUD	2048
-#endif /* CONFIG_64BIT */
 #define PTRS_PER_PGD	2048
 
 #define FIRST_USER_ADDRESS  0UL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
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
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

