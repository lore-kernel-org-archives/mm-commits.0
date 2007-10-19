From: akpm@linux-foundation.org
Subject: - whitespace-fixes-cpuset.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:34 -0700
Message-ID: <200710190343.l9J3hYYl013072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966496AbXJSDz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: cpuset
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-cpuset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: cpuset
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/cpuset.c~whitespace-fixes-cpuset kernel/cpuset.c
--- a/kernel/cpuset.c~whitespace-fixes-cpuset
+++ a/kernel/cpuset.c
@@ -2431,12 +2431,12 @@ int __cpuset_zone_allowed_hardwall(struc
 	node = zone_to_nid(z);
 	if (node_isset(node, current->mems_allowed))
 		return 1;
-        /*
-         * Allow tasks that have access to memory reserves because they have
-         * been OOM killed to get memory anywhere.
-         */
-        if (unlikely(test_thread_flag(TIF_MEMDIE)))
-                return 1;
+	/*
+	 * Allow tasks that have access to memory reserves because they have
+	 * been OOM killed to get memory anywhere.
+	 */
+	if (unlikely(test_thread_flag(TIF_MEMDIE)))
+		return 1;
 	return 0;
 }
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
