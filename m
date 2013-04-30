From: akpm@linux-foundation.org
Subject: [merged] mm-walk_memory_range-fix-typo-in-comment.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:41 -0700
Message-ID: <20130430184441.67ED731C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38160 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab3D3Som (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:42 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so84680vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: walk_memory_range(): fix typo in comment
has been removed from the -mm tree.  Its filename was
     mm-walk_memory_range-fix-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm: walk_memory_range(): fix typo in comment

Fix a typo "end_pft" in the comment of walk_memory_range().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-walk_memory_range-fix-typo-in-comment mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-walk_memory_range-fix-typo-in-comment
+++ a/mm/memory_hotplug.c
@@ -1613,7 +1613,7 @@ int offline_pages(unsigned long start_pf
 /**
  * walk_memory_range - walks through all mem sections in [start_pfn, end_pfn)
  * @start_pfn: start pfn of the memory range
- * @end_pfn: end pft of the memory range
+ * @end_pfn: end pfn of the memory range
  * @arg: argument passed to func
  * @func: callback for each memory section walked
  *
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
linux-next.patch

