From: akpm@linux-foundation.org
Subject: [folded] memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:31:33 -0700
Message-ID: <200909232231.n8NMVXte021349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbZIWWbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:31:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory-controller-soft-limit-reclaim-on-contention-v9-fix
has been removed from the -mm tree.  Its filename was
     memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch

This patch was dropped because it was folded into memory-controller-soft-limit-reclaim-on-contention-v9.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory-controller-soft-limit-reclaim-on-contention-v9-fix
From: Andrew Morton <akpm@linux-foundation.org>

build fix

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memory-controller-soft-limit-reclaim-on-contention-v9-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memory-controller-soft-limit-reclaim-on-contention-v9-fix
+++ a/include/linux/memcontrol.h
@@ -281,8 +281,7 @@ static inline void mem_cgroup_update_map
 
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask, int nid,
-						int zid, int priority)
+					    gfp_t gfp_mask, int nid, int zid)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch

