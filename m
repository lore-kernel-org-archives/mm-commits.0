From: akpm@linux-foundation.org
Subject: [folded-merged]
 acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:31:55 -0800
Message-ID: <52df036b.WHABm1eu5oPHlYKy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaAUXb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:31:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, tangchen@cn.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,tangchen@cn.fujitsu.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:31:55 -0800


The patch titled
     Subject: acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch

This patch was dropped because it was folded into acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes

WARNING: line over 80 characters
#65: FILE: arch/x86/mm/srat.c:187:
+			(unsigned long long) start, (unsigned long long) end - 1);

total: 0 errors, 1 warnings, 19 lines checked

./patches/acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/srat.c~acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes
+++ a/arch/x86/mm/srat.c
@@ -194,7 +194,7 @@ acpi_numa_memory_affinity_init(struct ac
 	/* Mark hotplug range in memblock. */
 	if (hotpluggable && memblock_mark_hotplug(start, ma->length))
 		pr_warn("SRAT: Failed to mark hotplug range [mem %#010Lx-%#010Lx] in memblock\n",
-			(unsigned long long) start, (unsigned long long) end - 1);
+			(unsigned long long)start, (unsigned long long)end - 1);
 
 	return 0;
 out_err_bad_srat:
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
mm-add-overcommit_kbytes-sysctl-variable.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

