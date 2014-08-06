From: akpm@linux-foundation.org
Subject: [folded-merged] slab-defer-slab_destroy-in-free_block-v4.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 15:44:27 -0700
Message-ID: <53e2afcb.DXSN02fwYed5GEi8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:37116 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaHFWo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:44:28 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so837817pdj.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:44:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-defer-slab_destroy-in-free_block-v4
has been removed from the -mm tree.  Its filename was
     slab-defer-slab_destroy-in-free_block-v4.patch

This patch was dropped because it was folded into slab-defer-slab_destroy-in-free_block.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab-defer-slab_destroy-in-free_block-v4

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slab.c~slab-defer-slab_destroy-in-free_block-v4 mm/slab.c
--- a/mm/slab.c~slab-defer-slab_destroy-in-free_block-v4
+++ a/mm/slab.c
@@ -3412,6 +3412,7 @@ slab_alloc(struct kmem_cache *cachep, gf
 
 /*
  * Caller needs to acquire correct kmem_cache_node's list_lock
+ * @list: List of detached free slabs should be freed by caller
  */
 static void free_block(struct kmem_cache *cachep, void **objpp,
 			int nr_objects, int node, struct list_head *list)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-trivial-comment-cleanup-in-slabc.patch
mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
cma-generalize-cma-reserved-area-management-functionality-fix.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch

