From: akpm@linux-foundation.org
Subject: + mm-slab-correct-config-option-in-comment.patch added to -mm
 tree
Date: Wed, 25 Mar 2015 14:46:14 -0700
Message-ID: <55132ca6.fNKVlRTxKghZXNkT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbCYVqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: correct config option in comment
has been added to the -mm tree.  Its filename is
     mm-slab-correct-config-option-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-correct-config-option-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-correct-config-option-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, slab: correct config option in comment

CONFIG_SLAB_DEBUG doesn't exist, CONFIG_DEBUG_SLAB does.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/slab.h~mm-slab-correct-config-option-in-comment include/linux/slab.h
--- a/include/linux/slab.h~mm-slab-correct-config-option-in-comment
+++ a/include/linux/slab.h
@@ -18,7 +18,7 @@
 
 /*
  * Flags to pass to kmem_cache_create().
- * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
+ * The ones marked DEBUG are only valid if CONFIG_DEBUG_SLAB is set.
  */
 #define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
_

Patches currently in -mm which might be from rientjes@google.com are

mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch
mm-memory-hotplog-postpone-the-reset-of-obsolete-pgdat.patch
mm-slub-fix-lockups-on-preempt-smp-kernels.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-slab-correct-config-option-in-comment.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-mempool-do-not-allow-atomic-resizing.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
allow-compaction-of-unevictable-pages.patch
mm-compaction-reset-compaction-scanner-positions.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mremap-should-return-enomem-when-__vm_enough_memory-fail.patch
clean-up-goto-just-return-err_ptr.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

