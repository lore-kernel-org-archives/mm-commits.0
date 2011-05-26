From: akpm@linux-foundation.org
Subject: [folded] memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:17:27 -0700
Message-ID: <201105262317.p4QNHRs8026362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EZXSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg-reclaim-memory-from-nodes-in-round-robin-fix
has been removed from the -mm tree.  Its filename was
     memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch

This patch was dropped because it was folded into memcg-reclaim-memory-from-nodes-in-round-robin-order.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-reclaim-memory-from-nodes-in-round-robin-fix
From: Andrew Morton <akpm@linux-foundation.org>

comment editing

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-fix
+++ a/mm/memcontrol.c
@@ -1508,9 +1508,9 @@ mem_cgroup_select_victim(struct mem_cgro
 #if MAX_NUMNODES > 1
 
 /*
- * Update nodemask always is not very good. Even if we have empty
- * list, or wrong list here, we can start from some node and traverse all nodes
- * based on zonelist. So, update the list loosely once in 10 secs.
+ * Always updating the nodemask is not very good - even if we have an empty
+ * list or the wrong list here, we can start from some node and traverse all
+ * nodes based on the zonelist. So update the list loosely once per 10 secs.
  *
  */
 static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
include-linux-hugetlbh-needs-mm_typesh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch
ufs-truncated-values-handling-64-bit-metadata.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
add-the-pagefault-count-into-memcg-stats.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

