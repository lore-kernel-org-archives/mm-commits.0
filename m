From: akpm@linux-foundation.org
Subject: + mm-docs-fixup-punctuation.patch added to -mm tree
Date: Fri, 26 Jan 2018 12:09:05 -0800
Message-ID: <20180126200905.GuzinAiwK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751484AbeAZUJH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jan 2018 15:09:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com


The patch titled
     Subject: mm: docs: fixup punctuation
has been added to the -mm tree.  Its filename is
     mm-docs-fixup-punctuation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-docs-fixup-punctuation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-docs-fixup-punctuation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: mm: docs: fixup punctuation

so that kernel-doc will properly recognize the parameter and function
descriptions.

Link: http://lkml.kernel.org/r/1516700871-22279-2-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c        |    2 +-
 mm/memcontrol.c |    4 ++--
 mm/mlock.c      |    2 +-
 mm/nommu.c      |    2 +-
 mm/zpool.c      |   44 ++++++++++++++++++++++----------------------
 5 files changed, 27 insertions(+), 27 deletions(-)

diff -puN mm/ksm.c~mm-docs-fixup-punctuation mm/ksm.c
--- a/mm/ksm.c~mm-docs-fixup-punctuation
+++ a/mm/ksm.c
@@ -2302,7 +2302,7 @@ next_mm:
 
 /**
  * ksm_do_scan  - the ksm scanner main worker function.
- * @scan_npages - number of pages we want to scan before we return.
+ * @scan_npages:  number of pages we want to scan before we return.
  */
 static void ksm_do_scan(unsigned int scan_npages)
 {
diff -puN mm/memcontrol.c~mm-docs-fixup-punctuation mm/memcontrol.c
--- a/mm/memcontrol.c~mm-docs-fixup-punctuation
+++ a/mm/memcontrol.c
@@ -6060,8 +6060,8 @@ bool mem_cgroup_charge_skmem(struct mem_
 
 /**
  * mem_cgroup_uncharge_skmem - uncharge socket memory
- * @memcg - memcg to uncharge
- * @nr_pages - number of pages to uncharge
+ * @memcg: memcg to uncharge
+ * @nr_pages: number of pages to uncharge
  */
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
diff -puN mm/mlock.c~mm-docs-fixup-punctuation mm/mlock.c
--- a/mm/mlock.c~mm-docs-fixup-punctuation
+++ a/mm/mlock.c
@@ -163,7 +163,7 @@ static void __munlock_isolation_failed(s
 
 /**
  * munlock_vma_page - munlock a vma page
- * @page - page to be unlocked, either a normal page or THP page head
+ * @page: page to be unlocked, either a normal page or THP page head
  *
  * returns the size of the page as a page mask (0 for normal page,
  *         HPAGE_PMD_NR - 1 for THP head page)
diff -puN mm/nommu.c~mm-docs-fixup-punctuation mm/nommu.c
--- a/mm/nommu.c~mm-docs-fixup-punctuation
+++ a/mm/nommu.c
@@ -1836,7 +1836,7 @@ int __access_remote_vm(struct task_struc
 }
 
 /**
- * @access_remote_vm - access another process' address space
+ * access_remote_vm - access another process' address space
  * @mm:		the mm_struct of the target address space
  * @addr:	start address to access
  * @buf:	source or destination buffer
diff -puN mm/sparse-vmemmap.c~mm-docs-fixup-punctuation mm/sparse-vmemmap.c
diff -puN mm/zpool.c~mm-docs-fixup-punctuation mm/zpool.c
--- a/mm/zpool.c~mm-docs-fixup-punctuation
+++ a/mm/zpool.c
@@ -101,7 +101,7 @@ static void zpool_put_driver(struct zpoo
 
 /**
  * zpool_has_pool() - Check if the pool driver is available
- * @type	The type of the zpool to check (e.g. zbud, zsmalloc)
+ * @type:	The type of the zpool to check (e.g. zbud, zsmalloc)
  *
  * This checks if the @type pool driver is available.  This will try to load
  * the requested module, if needed, but there is no guarantee the module will
@@ -136,10 +136,10 @@ EXPORT_SYMBOL(zpool_has_pool);
 
 /**
  * zpool_create_pool() - Create a new zpool
- * @type	The type of the zpool to create (e.g. zbud, zsmalloc)
- * @name	The name of the zpool (e.g. zram0, zswap)
- * @gfp		The GFP flags to use when allocating the pool.
- * @ops		The optional ops callback.
+ * @type:	The type of the zpool to create (e.g. zbud, zsmalloc)
+ * @name:	The name of the zpool (e.g. zram0, zswap)
+ * @gfp:	The GFP flags to use when allocating the pool.
+ * @ops:	The optional ops callback.
  *
  * This creates a new zpool of the specified type.  The gfp flags will be
  * used when allocating memory, if the implementation supports it.  If the
@@ -201,7 +201,7 @@ struct zpool *zpool_create_pool(const ch
 
 /**
  * zpool_destroy_pool() - Destroy a zpool
- * @pool	The zpool to destroy.
+ * @pool:	The zpool to destroy.
  *
  * Implementations must guarantee this to be thread-safe,
  * however only when destroying different pools.  The same
@@ -224,7 +224,7 @@ void zpool_destroy_pool(struct zpool *zp
 
 /**
  * zpool_get_type() - Get the type of the zpool
- * @pool	The zpool to check
+ * @pool:	The zpool to check
  *
  * This returns the type of the pool.
  *
@@ -239,10 +239,10 @@ const char *zpool_get_type(struct zpool
 
 /**
  * zpool_malloc() - Allocate memory
- * @pool	The zpool to allocate from.
- * @size	The amount of memory to allocate.
- * @gfp		The GFP flags to use when allocating memory.
- * @handle	Pointer to the handle to set
+ * @pool:	The zpool to allocate from.
+ * @size:	The amount of memory to allocate.
+ * @gfp:	The GFP flags to use when allocating memory.
+ * @handle:	Pointer to the handle to set
  *
  * This allocates the requested amount of memory from the pool.
  * The gfp flags will be used when allocating memory, if the
@@ -261,8 +261,8 @@ int zpool_malloc(struct zpool *zpool, si
 
 /**
  * zpool_free() - Free previously allocated memory
- * @pool	The zpool that allocated the memory.
- * @handle	The handle to the memory to free.
+ * @pool:	The zpool that allocated the memory.
+ * @handle:	The handle to the memory to free.
  *
  * This frees previously allocated memory.  This does not guarantee
  * that the pool will actually free memory, only that the memory
@@ -280,9 +280,9 @@ void zpool_free(struct zpool *zpool, uns
 
 /**
  * zpool_shrink() - Shrink the pool size
- * @pool	The zpool to shrink.
- * @pages	The number of pages to shrink the pool.
- * @reclaimed	The number of pages successfully evicted.
+ * @pool:	The zpool to shrink.
+ * @pages:	The number of pages to shrink the pool.
+ * @reclaimed:	The number of pages successfully evicted.
  *
  * This attempts to shrink the actual memory size of the pool
  * by evicting currently used handle(s).  If the pool was
@@ -304,9 +304,9 @@ int zpool_shrink(struct zpool *zpool, un
 
 /**
  * zpool_map_handle() - Map a previously allocated handle into memory
- * @pool	The zpool that the handle was allocated from
- * @handle	The handle to map
- * @mm		How the memory should be mapped
+ * @pool:	The zpool that the handle was allocated from
+ * @handle:	The handle to map
+ * @mm:		How the memory should be mapped
  *
  * This maps a previously allocated handle into memory.  The @mm
  * param indicates to the implementation how the memory will be
@@ -332,8 +332,8 @@ void *zpool_map_handle(struct zpool *zpo
 
 /**
  * zpool_unmap_handle() - Unmap a previously mapped handle
- * @pool	The zpool that the handle was allocated from
- * @handle	The handle to unmap
+ * @pool:	The zpool that the handle was allocated from
+ * @handle:	The handle to unmap
  *
  * This unmaps a previously mapped handle.  Any locks or other
  * actions that the implementation took in zpool_map_handle()
@@ -347,7 +347,7 @@ void zpool_unmap_handle(struct zpool *zp
 
 /**
  * zpool_get_total_size() - The total size of the pool
- * @pool	The zpool to check
+ * @pool:	The zpool to check
  *
  * This returns the total size in bytes of the pool.
  *
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

mm-update-comment-describing-tlb_gather_mmu.patch
pids-introduce-find_get_task_by_vpid-helper.patch
mm-docs-fix-parameter-names-mismatch.patch
mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors.patch
mm-docs-fixup-punctuation.patch

