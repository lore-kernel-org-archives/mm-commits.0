From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-embed-migration-mode-in-compact_control-fix.patch removed
 from -mm tree
Date: Wed, 04 Jun 2014 15:29:17 -0700
Message-ID: <538f9dbd.BZq7+V6jYedtAqd9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaFDW3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com, n-horiguchi@ah.jp.nec.com, gthelen@google.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-compaction-embed-migration-mode-in-compact_control-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,gthelen@google.com,n-horiguchi@ah.jp.nec.com,rientjes@google.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:29:17 -0700


The patch titled
     Subject: mm-compaction-embed-migration-mode-in-compact_control-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-embed-migration-mode-in-compact_control-fix.patch

This patch was dropped because it was folded into mm-compaction-embed-migration-mode-in-compact_control.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-embed-migration-mode-in-compact_control-fix

fix build

mm/page_alloc.c: In function 'alloc_contig_range':
mm/page_alloc.c:6255: error: unknown field 'sync' specified in initializer

Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-compaction-embed-migration-mode-in-compact_control-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-embed-migration-mode-in-compact_control-fix
+++ a/mm/page_alloc.c
@@ -6252,7 +6252,7 @@ int alloc_contig_range(unsigned long sta
 		.nr_migratepages = 0,
 		.order = -1,
 		.zone = page_zone(pfn_to_page(start)),
-		.sync = MIGRATE_SYNC_LIGHT,
+		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
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
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

