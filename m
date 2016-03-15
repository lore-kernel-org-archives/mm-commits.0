From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch removed from -mm tree
Date: Tue, 15 Mar 2016 14:36:29 -0700
Message-ID: <56e8805d.Wf5Kok3FGcL4ko36%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcCOVga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:36:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-put-the-freelist-at-the-end-of-slab-page-fix
has been removed from the -mm tree.  Its filename was
     mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch

This patch was dropped because it was folded into mm-slab-put-the-freelist-at-the-end-of-slab-page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slab-put-the-freelist-at-the-end-of-slab-page-fix

fix kerneldoc

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/slab.c~mm-slab-put-the-freelist-at-the-end-of-slab-page-fix mm/slab.c
--- a/mm/slab.c~mm-slab-put-the-freelist-at-the-end-of-slab-page-fix
+++ a/mm/slab.c
@@ -1868,7 +1868,6 @@ static void slabs_destroy(struct kmem_ca
  * calculate_slab_order - calculate size (page order) of slabs
  * @cachep: pointer to the cache that is being created
  * @size: size of objects to be created in this cache.
- * @align: required alignment for the objects.
  * @flags: slab allocation flags
  *
  * Also calculates the number of objects per slab.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

