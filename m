From: akpm@linux-foundation.org
Subject: [merged] mm-slub-fix-typo.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:39 -0800
Message-ID: <54dbb9d3.aGvc7m2QEh9qRcQk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbbBKUVk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kim.phillips@freescale.com, cl@linux.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: fix typo in comment
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kim Phillips <kim.phillips@freescale.com>
Subject: mm/slub.c: fix typo in comment

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~mm-slub-fix-typo mm/slub.c
--- a/mm/slub.c~mm-slub-fix-typo
+++ a/mm/slub.c
@@ -2521,7 +2521,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_trac
 #endif
 
 /*
- * Slow patch handling. This may still be called frequently since objects
+ * Slow path handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
  *
  * So we still attempt to reduce cache line usage. Just take the slab
_

Patches currently in -mm which might be from kim.phillips@freescale.com are

origin.patch
linux-next.patch

