From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:41 -0800
Message-ID: <201101142252.p0EMqVIY005635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1ANWwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove unnecessary return from void-returning mem_cgroup_del_lru_list()
has been removed from the -mm tree.  Its filename was
     memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove unnecessary return from void-returning mem_cgroup_del_lru_list()
From: Minchan Kim <minchan.kim@gmail.com>

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list
+++ a/mm/memcontrol.c
@@ -821,7 +821,6 @@ void mem_cgroup_del_lru_list(struct page
 		return;
 	VM_BUG_ON(list_empty(&pc->lru));
 	list_del_init(&pc->lru);
-	return;
 }
 
 void mem_cgroup_del_lru(struct page *page)
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-vmap-area-cache.patch
mm-vmap-area-cache-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

