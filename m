From: akpm@linux-foundation.org
Subject: [folded] memcg-improve-resource-counter-scalability-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:32:46 -0700
Message-ID: <200909232232.n8NMWkHr023717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbZIWWcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg-improve-resource-counter-scalability-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-improve-resource-counter-scalability-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-improve-resource-counter-scalability.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-improve-resource-counter-scalability-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: spaces required around that '?' (ctx:VxW)
#50: FILE: mm/memcontrol.c:485:
+	int val = (charge)? 1 : -1;
 	                  ^

total: 1 errors, 0 warnings, 171 lines checked

./patches/memcg-improve-resource-counter-scalability.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-improve-resource-counter-scalability-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-improve-resource-counter-scalability-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -482,7 +482,7 @@ mem_cgroup_largest_soft_limit_node(struc
 static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
 					 bool charge)
 {
-	int val = (charge)? 1 : -1;
+	int val = (charge) ? 1 : -1;
 	struct mem_cgroup_stat *stat = &mem->stat;
 	struct mem_cgroup_stat_cpu *cpustat;
 	int cpu = get_cpu();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch

