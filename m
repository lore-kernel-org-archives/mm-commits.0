From: akpm@linux-foundation.org
Subject: + memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch added to -mm tree
Date: Tue, 12 Jan 2010 15:40:01 -0800
Message-ID: <201001122340.o0CNe1El002288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab0ALXkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 18:40:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org


The patch titled
     memcg: typo in comment to mem_cgroup_print_oom_info()
has been added to the -mm tree.  Its filename is
     memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

cgroups-fix-contents-in-cgroups-documentation.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch

