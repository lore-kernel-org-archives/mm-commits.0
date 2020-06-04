From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 052/127] mm/memory_hotplug: fix a typo in comment
 "recoreded"->"recorded"
Date: Thu, 04 Jun 2020 16:48:58 -0700
Message-ID: <20200604234858.bpzBwD-So%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:00 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

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
