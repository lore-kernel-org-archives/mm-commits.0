From: akpm@linux-foundation.org
Subject: [merged] memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:59:15 -0400
Message-ID: <201003150659.o2F6xm27016572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935633Ab0COG74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: typo in comment to mem_cgroup_print_oom_info()
has been removed from the -mm tree.  Its filename was
     memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: typo in comment to mem_cgroup_print_oom_info()
From: "Kirill A. Shutemov" <kirill@shutemov.name>

s/mem_cgroup_print_mem_info/mem_cgroup_print_oom_info/

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-typo-in-comment-to-mem_cgroup_print_oom_info mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-typo-in-comment-to-mem_cgroup_print_oom_info
+++ a/mm/memcontrol.c
@@ -1070,7 +1070,7 @@ static int mem_cgroup_count_children_cb(
 }
 
 /**
- * mem_cgroup_print_mem_info: Called from OOM with tasklist_lock held in read mode.
+ * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
  * @memcg: The memory cgroup that went over limit
  * @p: Task that is going to be killed
  *
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

