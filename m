From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmscan-force-scan-offline-memory-cgroups-fix.patch removed from -mm tree
Date: Wed, 11 Feb 2015 15:13:35 -0800
Message-ID: <54dbe21f.Jx/DS+ibOtF06C1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbBKXNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan-force-scan-offline-memory-cgroups-fix
has been removed from the -mm tree.  Its filename was
     vmscan-force-scan-offline-memory-cgroups-fix.patch

This patch was dropped because it was folded into vmscan-force-scan-offline-memory-cgroups.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmscan-force-scan-offline-memory-cgroups-fix

thou shalt memorize Documentation/SubmitChecklist

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~vmscan-force-scan-offline-memory-cgroups-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-force-scan-offline-memory-cgroups-fix
+++ a/include/linux/memcontrol.h
@@ -267,7 +267,7 @@ mem_cgroup_inactive_anon_is_low(struct l
 	return 1;
 }
 
-bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
+static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
 {
 	return true;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch

