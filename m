From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:28:53 -0800
Message-ID: <52df02b5.jRA+p/mqB4GdyzPM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaAUX2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,isimatu.yasuaki@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:28:53 -0800


The patch titled
     Subject: mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch

This patch was dropped because it was folded into mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix

tweak comment

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix
+++ a/mm/page_alloc.c
@@ -3968,7 +3968,7 @@ static void setup_zone_migrate_reserve(s
 			}
 		} else if (!old_reserve) {
 			/*
-			 * When boot time, we don't need scan whole zone
+			 * At boot time we don't need to scan the whole zone
 			 * for turning off MIGRATE_RESERVE.
 			 */
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
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

