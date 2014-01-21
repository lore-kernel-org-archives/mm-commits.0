From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memblock-add-memblock-memory-allocation-apis-fix.patch removed from -mm
 tree
Date: Tue, 21 Jan 2014 15:33:41 -0800
Message-ID: <52df03d5.5dkCgozJjWlxv+mL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaAUXdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:33:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, akpm@linux-foundation.org

Subject: [folded-merged] mm-memblock-add-memblock-memory-allocation-apis-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:33:41 -0800


The patch titled
     Subject: mm-memblock-add-memblock-memory-allocation-apis-fix
has been removed from the -mm tree.  Its filename was
     mm-memblock-add-memblock-memory-allocation-apis-fix.patch

This patch was dropped because it was folded into mm-memblock-add-memblock-memory-allocation-apis.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memblock-add-memblock-memory-allocation-apis-fix

s/depricated/deprecated/

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memblock.c~mm-memblock-add-memblock-memory-allocation-apis-fix mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-memblock-memory-allocation-apis-fix
+++ a/mm/memblock.c
@@ -788,7 +788,7 @@ void __init_memblock __next_free_mem_ran
 	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
 
 	if (nid == MAX_NUMNODES)
-		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
+		pr_warn_once("%s: Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n",
 			     __func__);
 
 	for ( ; mi < mem->cnt; mi++) {
@@ -861,7 +861,7 @@ void __init_memblock __next_free_mem_ran
 	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
 
 	if (nid == MAX_NUMNODES)
-		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
+		pr_warn_once("%s: Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n",
 			     __func__);
 
 	if (*idx == (u64)ULLONG_MAX) {
@@ -1068,7 +1068,7 @@ static void * __init memblock_virt_alloc
 	void *ptr;
 
 	if (nid == MAX_NUMNODES)
-		pr_warn("%s: usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE\n",
+		pr_warn("%s: usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE\n",
 			__func__);
 
 	if (WARN_ON_ONCE(slab_is_available()))
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
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

