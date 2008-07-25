From: akpm@linux-foundation.org
Subject: - taskstats-remove-initialization-of-static-per-cpu-variable.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:23 -0700
Message-ID: <200807252303.m6PN3NBN003950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbYGYXD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, balbir@in.ibm.com, nagar@watson.ibm.com, mm-commits@vger.kernel.org


The patch titled
     taskstats: remove initialization of static per-cpu variable
has been removed from the -mm tree.  Its filename was
     taskstats-remove-initialization-of-static-per-cpu-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taskstats: remove initialization of static per-cpu variable
From: Vegard Nossum <vegard.nossum@gmail.com>

Cc: Shailabh Nagar <nagar@watson.ibm.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/taskstats.c~taskstats-remove-initialization-of-static-per-cpu-variable kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-remove-initialization-of-static-per-cpu-variable
+++ a/kernel/taskstats.c
@@ -35,7 +35,7 @@
  */
 #define TASKSTATS_CPUMASK_MAXLEN	(100+6*NR_CPUS)
 
-static DEFINE_PER_CPU(__u32, taskstats_seqnum) = { 0 };
+static DEFINE_PER_CPU(__u32, taskstats_seqnum);
 static int family_registered;
 struct kmem_cache *taskstats_cache;
 
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
parisc-fix-incomplete-header-guard.patch

