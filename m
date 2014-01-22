From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:42 -0800
Message-ID: <52e0263a.v1V9+JCboos1VWqK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wuzhy@linux.vnet.ibm.com

Subject: [merged] mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch removed from -mm tree
To: wuzhy@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:42 -0800


The patch titled
     Subject: mm, memory-failure: fix typo in me_pagecache_dirty()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: mm, memory-failure: fix typo in me_pagecache_dirty()

[akpm@linux-foundation.org: s/cache/pagecache/]
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty
+++ a/mm/memory-failure.c
@@ -611,7 +611,7 @@ static int me_pagecache_clean(struct pag
 }
 
 /*
- * Dirty cache page page
+ * Dirty pagecache page
  * Issues: when the error hit a hole page the error is not properly
  * propagated.
  */
_

Patches currently in -mm which might be from wuzhy@linux.vnet.ibm.com are

origin.patch
linux-next.patch

