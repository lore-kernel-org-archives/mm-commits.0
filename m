From: akpm@linux-foundation.org
Subject: [merged] mm-unexport-find_get_entry.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:36:21 -0700
Message-ID: <20200403203621.S7ckyG2VD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/filemap.c: unexport find_get_entry
has been removed from the -mm tree.  Its filename was
     mm-unexport-find_get_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap.c: unexport find_get_entry

No in-tree users (proc, madvise, memcg, mincore) can be built as a module.

Link: http://lkml.kernel.org/r/20200318140253.6141-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/filemap.c~mm-unexport-find_get_entry
+++ a/mm/filemap.c
@@ -1536,7 +1536,6 @@ out:
 
 	return page;
 }
-EXPORT_SYMBOL(find_get_entry);
 
 /**
  * find_lock_entry - locate, pin and lock a page cache entry
_

Patches currently in -mm which might be from willy@infradead.org are

mm-optimise-find_subpage-for-thp.patch
mm-remove-config_transparent_huge_pagecache.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch
