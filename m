From: akpm@linux-foundation.org
Subject: [folded-merged]
 slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch removed
 from -mm tree
Date: Wed, 06 Aug 2014 15:43:31 -0700
Message-ID: <53e2af93.tp9w/LF+6zIDf+LS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:48284 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaHFWnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:43:32 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so614217obb.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:43:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix
has been removed from the -mm tree.  Its filename was
     slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch

This patch was dropped because it was folded into slab-use-get_node-and-kmem_cache_node-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix

Cc: Christoph Lameter <cl@linux.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix mm/slab.c
--- a/mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix
+++ a/mm/slab.c
@@ -590,7 +590,8 @@ static inline void on_slab_lock_classes_
 {
 }
 
-static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
+static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep,
+	struct kmem_cache_node *n)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

