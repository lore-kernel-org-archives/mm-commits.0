From: akpm@linux-foundation.org
Subject: [folded-merged] ksm-trivial-tidyups-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:53:13 -0800
Message-ID: <20130222235314.0D5355A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:57562 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab3BVXxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:53:15 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so137085qah.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:53:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-trivial-tidyups-fix
has been removed from the -mm tree.  Its filename was
     ksm-trivial-tidyups-fix.patch

This patch was dropped because it was folded into ksm-trivial-tidyups.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm-trivial-tidyups-fix

Suggested by akpm: make DO_NUMA(x) do { (x); } while (0) more like the #else.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-trivial-tidyups-fix mm/ksm.c
--- a/mm/ksm.c~ksm-trivial-tidyups-fix
+++ a/mm/ksm.c
@@ -43,7 +43,7 @@
 
 #ifdef CONFIG_NUMA
 #define NUMA(x)		(x)
-#define DO_NUMA(x)	(x)
+#define DO_NUMA(x)	do { (x); } while (0)
 #else
 #define NUMA(x)		(0)
 #define DO_NUMA(x)	do { } while (0)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-add-per-partition-lock-for-swapfile.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-shmem-use-new-radix-tree-iterator.patch
mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch
mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts.patch
mm-use-up-free-swap-space-before-reaching-oom-kill.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
tmpfs-fix-use-after-free-of-mempolicy-object.patch
tmpfs-fix-mempolicy-object-leaks.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch
ksm-add-some-comments.patch
ksm-treat-unstable-nid-like-in-stable-tree.patch
ksm-shrink-32-bit-rmap_item-back-to-32-bytes.patch
mmksm-foll_migration-do-migration_entry_wait.patch
mmksm-swapoff-might-need-to-copy.patch
mm-cleanup-swapcache-in-do_swap_page.patch
ksm-allocate-roots-when-needed.patch

