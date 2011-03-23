From: akpm@linux-foundation.org
Subject: [folded] memcg-change-page_cgroup_zoneinfo-signature-fix.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:19:10 -0700
Message-ID: <201103232319.p2NNJAYw004316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933183Ab1CWXTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-change-page_cgroup_zoneinfo-signature-fix
has been removed from the -mm tree.  Its filename was
     memcg-change-page_cgroup_zoneinfo-signature-fix.patch

This patch was dropped because it was folded into memcg-change-page_cgroup_zoneinfo-signature.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-change-page_cgroup_zoneinfo-signature-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-change-page_cgroup_zoneinfo-signature-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-page_cgroup_zoneinfo-signature-fix
+++ a/mm/memcontrol.c
@@ -835,7 +835,7 @@ void mem_cgroup_rotate_reclaimable_page(
 	smp_rmb();
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move_tail(&pc->lru, &mz->lists[lru]);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

