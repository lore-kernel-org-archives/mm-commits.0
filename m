From: akpm@linux-foundation.org
Subject: [folded] vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:58:43 -0700
Message-ID: <201107262258.p6QMwiRH014718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890Ab1GZW7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:59:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dtor@vmware.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix
has been removed from the -mm tree.  Its filename was
     vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch

This patch was dropped because it was folded into vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment layout & grammar

Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmw_balloon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/vmw_balloon.c~vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix drivers/misc/vmw_balloon.c
--- a/drivers/misc/vmw_balloon.c~vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix
+++ a/drivers/misc/vmw_balloon.c
@@ -674,9 +674,9 @@ static void vmballoon_work(struct work_s
 	}
 
 	/*
-	 * We are using freezable workqueue so that balloon operations are
-	 * stopped while system transitions to/from sleep/hibernation.
-	*/
+	 * We are using a freezable workqueue so that balloon operations are
+	 * stopped while the system transitions to/from sleep/hibernation.
+	 */
 	queue_delayed_work(system_freezable_wq,
 			   dwork, round_jiffies_relative(HZ));
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch

