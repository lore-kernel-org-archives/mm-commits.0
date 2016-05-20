From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch removed from
 -mm tree
Date: Fri, 20 May 2016 16:37:56 -0700
Message-ID: <573f9fd4.OwEL+tK2oY7VA64S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETXh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix
has been removed from the -mm tree.  Its filename was
     vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch

This patch was dropped because it was folded into vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix

fix indentation, per Michal

Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix mm/vmstat.c
--- a/mm/vmstat.c~vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix
+++ a/mm/vmstat.c
@@ -1500,7 +1500,7 @@ static void vmstat_shepherd(struct work_
 		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
 
 		if (!delayed_work_pending(dw) && need_update(cpu))
-				queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
+			queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
 	}
 	put_online_cpus();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2.patch
mm-compact-fix-zoneindex-in-compact-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

