From: akpm@linux-foundation.org
Subject: + whitespace-fixes-cpuset.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:40 -0700
Message-ID: <200707210018.l6L0Ie4u023852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449AbXGUAT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:19:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, pj@sgi.com


The patch titled
     whitespace fixes: cpuset
has been added to the -mm tree.  Its filename is
     whitespace-fixes-cpuset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: cpuset
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/cpuset.c~whitespace-fixes-cpuset kernel/cpuset.c
--- a/kernel/cpuset.c~whitespace-fixes-cpuset
+++ a/kernel/cpuset.c
@@ -1647,12 +1647,12 @@ int __cpuset_zone_allowed_hardwall(struc
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

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
