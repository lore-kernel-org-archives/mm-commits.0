From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-show_mem-remove-show_mem_filter_page_count-fix.patch removed from -mm
 tree
Date: Tue, 21 Jan 2014 15:29:50 -0800
Message-ID: <52df02ee.AngHX/bVoljrXlky%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaAUX3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:29:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, rientjes@google.com, mgorman@suse.de, linux@arm.linux.org.uk, jejb@parisc-linux.org, akpm@linux-foundation.org

Subject: [folded-merged] mm-show_mem-remove-show_mem_filter_page_count-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jejb@parisc-linux.org,linux@arm.linux.org.uk,mgorman@suse.de,rientjes@google.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:29:50 -0800


The patch titled
     Subject: mm-show_mem-remove-show_mem_filter_page_count-fix
has been removed from the -mm tree.  Its filename was
     mm-show_mem-remove-show_mem_filter_page_count-fix.patch

This patch was dropped because it was folded into mm-show_mem-remove-show_mem_filter_page_count.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-show_mem-remove-show_mem_filter_page_count-fix

fix parisc

Cc: David Rientjes <rientjes@google.com>
Cc: James Bottomley <jejb@parisc-linux.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/init.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/parisc/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count-fix arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count-fix
+++ a/arch/parisc/mm/init.c
@@ -663,9 +663,6 @@ void show_mem(unsigned int filter)
 
 			total += zone->present_pages;
 			reserved = zone->present_pages - zone->managed_pages;
-
-			if (is_highmem_idx(zoneid))
-				highmem += zone->present_pages;
 		}
 		pgdat_resize_unlock(pgdat, &flags);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

