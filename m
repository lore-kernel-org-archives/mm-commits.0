From: akpm@linux-foundation.org
Subject: [merged] mm-fix-slabc-kernel-doc-warnings.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:21:49 -0800
Message-ID: <20121126222149.AA6D9100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57949 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2KZWVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:21:50 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so1367573qcq.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:21:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, cl@linux-foundation.org, mpm@selenic.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix slab.c kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     mm-fix-slabc-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix slab.c kernel-doc warnings

Fix new kernel-doc warnings in mm/slab.c:

Warning(mm/slab.c:2358): No description found for parameter 'cachep'
Warning(mm/slab.c:2358): Excess function parameter 'name' description in '__kmem_cache_create'
Warning(mm/slab.c:2358): Excess function parameter 'size' description in '__kmem_cache_create'
Warning(mm/slab.c:2358): Excess function parameter 'align' description in '__kmem_cache_create'
Warning(mm/slab.c:2358): Excess function parameter 'ctor' description in '__kmem_cache_create'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/slab.c~mm-fix-slabc-kernel-doc-warnings mm/slab.c
--- a/mm/slab.c~mm-fix-slabc-kernel-doc-warnings
+++ a/mm/slab.c
@@ -2349,11 +2349,8 @@ static int __init_refok setup_cpu_cache(
 
 /**
  * __kmem_cache_create - Create a cache.
- * @name: A string which is used in /proc/slabinfo to identify this cache.
- * @size: The size of objects to be created in this cache.
- * @align: The required alignment for the objects.
+ * @cachep: cache management descriptor
  * @flags: SLAB flags
- * @ctor: A constructor for the objects.
  *
  * Returns a ptr to the cache on success, NULL on failure.
  * Cannot be called within a int, but can be interrupted.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix.patch
printk-boot_delay-should-only-affect-output.patch

