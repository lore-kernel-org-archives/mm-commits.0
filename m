From: akpm@linux-foundation.org
Subject: - whitespace-fixes-task-exit-handling.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:16 -0700
Message-ID: <200710192251.l9JMpGbs024170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764673AbXJSXFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: task exit handling
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-task-exit-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: task exit handling
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~whitespace-fixes-task-exit-handling kernel/exit.c
--- a/kernel/exit.c~whitespace-fixes-task-exit-handling
+++ a/kernel/exit.c
@@ -405,7 +405,7 @@ void daemonize(const char *name, ...)
 		switch_task_namespaces(current, init_task.nsproxy);
 	}
 
- 	exit_files(current);
+	exit_files(current);
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
 
@@ -790,7 +790,7 @@ static void exit_notify(struct task_stru
 	/* Let father know we died
 	 *
 	 * Thread signals are configurable, but you aren't going to use
-	 * that to send signals to arbitary processes. 
+	 * that to send signals to arbitary processes.
 	 * That stops right now.
 	 *
 	 * If the parent exec id doesn't match the exec id we saved
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
