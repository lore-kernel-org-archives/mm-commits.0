From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix.patch removed from -mm tree
Date: Thu, 06 Jul 2017 15:15:24 -0700
Message-ID: <595eb67c.PtSDzrDhMet62RwQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdGFWPZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, richard.weiyang@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix

remove unused local `i'.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix
+++ a/mm/memory_hotplug.c
@@ -1081,7 +1081,6 @@ void move_pfn_range_to_zone(struct zone
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
 	unsigned long flags;
-	unsigned long i;
 
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch

