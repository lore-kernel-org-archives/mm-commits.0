From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:48:27 -0700
Message-ID: <538fa23b.gjALHp2Ww0L/Duy+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFDWs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, akpm@linux-foundation.org

Subject: [folded-merged] mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:48:27 -0700


The patch titled
     Subject: mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch

This patch was dropped because it was folded into mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix

fix typo in comment

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix
+++ a/mm/compaction.c
@@ -224,9 +224,9 @@ static bool compact_checklock_irqsave(sp
 
 /*
  * Aside from avoiding lock contention, compaction also periodically checks
- * need_resched() and either schedules in sync compaction, or aborts async
- * compaction. This is similar to compact_checklock_irqsave() does, but used
- * where no lock is concerned.
+ * need_resched() and either schedules in sync compaction or aborts async
+ * compaction. This is similar to what compact_checklock_irqsave() does, but
+ * is used where no lock is concerned.
  *
  * Returns false when no scheduling was needed, or sync compaction scheduled.
  * Returns true when async compaction should abort.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
swap-use-bdev_read_page-bdev_write_page.patch
mm-update-comment-for-default_max_map_count.patch
memcg-fold-mem_cgroup_stolen.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

