From: akpm@linux-foundation.org
Subject: + mm-fix-some-spelling.patch added to -mm tree
Date: Tue, 26 Jan 2016 20:40:14 -0800
Message-ID: <56a84a2e.I42bBk+ASCOUULt2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbcA0EkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 23:40:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some spelling
has been added to the -mm tree.  Its filename is
     mm-fix-some-spelling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-some-spelling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-some-spelling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm: fix some spelling

Fixup trivial spelling errors, noticed while reading the code.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---

index cd0e2413c358..e88c57e83215 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 include/linux/slab.h       |    2 +-
 mm/slab.h                  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~mm-fix-some-spelling include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-fix-some-spelling
+++ a/include/linux/memcontrol.h
@@ -765,7 +765,7 @@ int __memcg_kmem_charge(struct page *pag
 void __memcg_kmem_uncharge(struct page *page, int order);
 
 /*
- * helper for acessing a memcg's index. It will be used as an index in the
+ * helper for accessing a memcg's index. It will be used as an index in the
  * child cache array in kmem_cache, and also to derive its name. This function
  * will return -1 when this is not a kmem-limited memcg.
  */
diff -puN include/linux/slab.h~mm-fix-some-spelling include/linux/slab.h
--- a/include/linux/slab.h~mm-fix-some-spelling
+++ a/include/linux/slab.h
@@ -314,7 +314,7 @@ void *kmem_cache_alloc(struct kmem_cache
 void kmem_cache_free(struct kmem_cache *, void *);
 
 /*
- * Bulk allocation and freeing operations. These are accellerated in an
+ * Bulk allocation and freeing operations. These are accelerated in an
  * allocator specific way to avoid taking locks repeatedly or building
  * metadata structures unnecessarily.
  *
diff -puN mm/slab.h~mm-fix-some-spelling mm/slab.h
--- a/mm/slab.h~mm-fix-some-spelling
+++ a/mm/slab.h
@@ -171,7 +171,7 @@ ssize_t slabinfo_write(struct file *file
 /*
  * Generic implementation of bulk operations
  * These are useful for situations in which the allocator cannot
- * perform optimizations. In that case segments of the objecct listed
+ * perform optimizations. In that case segments of the object listed
  * may be allocated or freed using these operations.
  */
 void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch
mm-fault-inject-take-over-bootstrap-kmem_cache-check.patch
slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
mm-kmemcheck-skip-object-if-slab-allocation-failed.patch
slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
slab-implement-bulk-alloc-in-slab-allocator.patch
slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
slab-implement-bulk-free-in-slab-allocator.patch
mm-new-api-kfree_bulk-for-slabslub-allocators.patch
mm-fix-some-spelling.patch

