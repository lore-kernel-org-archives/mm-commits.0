From: akpm@linux-foundation.org
Subject: - krealloc-fix-kerneldoc-comments.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:18 -0700
Message-ID: <200705092148.l49LmICP002574@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759352AbXEIVsv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     krealloc: fix kerneldoc comments
has been removed from the -mm tree.  Its filename was
     krealloc-fix-kerneldoc-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: krealloc: fix kerneldoc comments
From: Pekka J Enberg <penberg@cs.helsinki.fi>

No "blank" (or "*") line is allowed between the function name and lines for
it parameter(s).

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 -
 mm/slub.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN mm/slab.c~krealloc-fix-kerneldoc-comments mm/slab.c
--- a/mm/slab.c~krealloc-fix-kerneldoc-comments
+++ a/mm/slab.c
@@ -3742,7 +3742,6 @@ EXPORT_SYMBOL(__kmalloc);
 
 /**
  * krealloc - reallocate memory. The contents will remain unchanged.
- *
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
  * @flags: the type of memory to allocate.
diff -puN mm/slub.c~krealloc-fix-kerneldoc-comments mm/slub.c
--- a/mm/slub.c~krealloc-fix-kerneldoc-comments
+++ a/mm/slub.c
@@ -2286,7 +2286,6 @@ EXPORT_SYMBOL(kmem_cache_shrink);
 
 /**
  * krealloc - reallocate memory. The contents will remain unchanged.
- *
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
  * @flags: the type of memory to allocate.
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
