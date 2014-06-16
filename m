From: akpm@linux-foundation.org
Subject: [nacked]
 pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch removed
 from -mm tree
Date: Mon, 16 Jun 2014 16:32:18 -0700
Message-ID: <539f7e82.viiTYq3MMefJZF1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaFPXcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, fengguang.wu@intel.com, akpm@linux-foundation.org


The patch titled
     Subject: pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix
has been removed from the -mm tree.  Its filename was
     pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix

remove the assertion altogether - the null deref is sufficient

Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/task_mmu.c~pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix
+++ a/fs/proc/task_mmu.c
@@ -1042,8 +1042,6 @@ static int pagemap_hugetlb(pte_t *pte, u
 	pagemap_entry_t pme;
 	unsigned long hmask;
 
-	BUG_ON(!vma);
-
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags2 = __PM_SOFT_DIRTY;
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
madvise-cleanup-swapin_walk_pmd_entry-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

