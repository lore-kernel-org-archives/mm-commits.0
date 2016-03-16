From: akpm@linux-foundation.org
Subject: [merged] mm-fix-some-spelling.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:02 -0700
Message-ID: <56e9b9da.0Mu8+9M0rCbcm1hG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbcCPTyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some spelling
has been removed from the -mm tree.  Its filename was
     mm-fix-some-spelling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm: fix some spelling

Fix up trivial spelling errors, noticed while reading the code.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
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
@@ -172,7 +172,7 @@ ssize_t slabinfo_write(struct file *file
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


