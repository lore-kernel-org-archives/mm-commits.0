From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:18:16 -0700
Message-ID: <20200605201816.iBFD-Vzjv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgFEUSR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/memory_hotplug: fix a typo in comment "recoreded"->"recorded"
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/memory_hotplug: fix a typo in comment "recoreded"->"recorded"

There is a typo in comment, fix it.
s/recoreded/recorded

Link: http://lkml.kernel.org/r/20200410160328.13843-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded
+++ a/mm/memory_hotplug.c
@@ -1337,7 +1337,7 @@ offline_isolated_pages_cb(unsigned long
 }
 
 /*
- * Check all pages in range, recoreded as memory resource, are isolated.
+ * Check all pages in range, recorded as memory resource, are isolated.
  */
 static int
 check_pages_isolated_cb(unsigned long start_pfn, unsigned long nr_pages,
_

Patches currently in -mm which might be from ethp@qq.com are
