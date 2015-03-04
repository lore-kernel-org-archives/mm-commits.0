From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-fix.patch removed from -mm tree
Date: Wed, 04 Mar 2015 12:52:56 -0800
Message-ID: <54f770a8.4aGujsi231uAiu4r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbbCDUw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 15:52:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chianglungyu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-fix.patch

This patch was dropped because it was folded into mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-fix

tweak comment

Cc: Leon Yu <chianglungyu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-fix mm/rmap.c
--- a/mm/rmap.c~mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-fix
+++ a/mm/rmap.c
@@ -290,8 +290,8 @@ int anon_vma_clone(struct vm_area_struct
 	/*
 	 * dst->anon_vma is dropped here otherwise its degree can be incorrectly
 	 * decremented in unlink_anon_vmas().
-	 * We can safely do this because calllers of anon_vma_clone() wouldn't
-	 * care dst->anon_vma if anon_vma_clone() failed.
+	 * We can safely do this because callers of anon_vma_clone() don't care
+	 * about dst->anon_vma if anon_vma_clone() failed.
 	 */
 	dst->anon_vma = NULL;
 	unlink_anon_vmas(dst);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
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

