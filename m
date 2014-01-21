From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:29:15 -0800
Message-ID: <52df02cb.Xq2F4hFONJJ1wgAL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaAUX3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:29:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wuzhy@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,wuzhy@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:29:15 -0800


The patch titled
     Subject: mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch

This patch was dropped because it was folded into mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix

s/cache/pagecache/

Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix
+++ a/mm/memory-failure.c
@@ -611,7 +611,7 @@ static int me_pagecache_clean(struct pag
 }
 
 /*
- * Dirty cache page
+ * Dirty pagecache page
  * Issues: when the error hit a hole page the error is not properly
  * propagated.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

