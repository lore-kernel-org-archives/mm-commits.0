From: akpm@linux-foundation.org
Subject: [folded] memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:36:07 -0800
Message-ID: <200912160036.nBG0a7t1023705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761446AbZLPAgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:36:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, lliubbo@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup
has been removed from the -mm tree.  Its filename was
     memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch

This patch was dropped because it was folded into memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup
+++ a/mm/memcontrol.c
@@ -2356,8 +2356,7 @@ static int mem_cgroup_resize_limit(struc
 		if (!ret)
 			break;
 
-		mem_cgroup_hierarchical_reclaim(memcg, NULL,
-						GFP_KERNEL,
+		mem_cgroup_hierarchical_reclaim(memcg, NULL, GFP_KERNEL,
 						MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 		/* Usage is reduced ? */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch

