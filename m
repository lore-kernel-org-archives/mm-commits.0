From: akpm@linux-foundation.org
Subject: [folded-merged]
 exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
 removed from -mm tree
Date: Fri, 20 May 2016 16:44:19 -0700
Message-ID: <573fa153.kKU5mb2eCKpQCo/K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcETXoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch

This patch was dropped because it was folded into exit_thread-accept-a-task-parameter-to-be-exited.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#242: FILE: arch/ia64/kernel/process.c:577:
+exit_thread (struct task_struct *tsk)

WARNING: braces {} are not necessary for single statement blocks
#331: FILE: arch/sh/kernel/process_64.c:310:
+	if (last_task_used_math == tsk) {
 		last_task_used_math = NULL;
 	}

total: 0 errors, 2 warnings, 231 lines checked

./patches/exit_thread-accept-a-task-parameter-to-be-exited.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/process_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/sh/kernel/process_64.c~exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes
+++ a/arch/sh/kernel/process_64.c
@@ -307,9 +307,8 @@ void exit_thread(struct task_struct *tsk
 	 * which it would get safely nulled.
 	 */
 #ifdef CONFIG_SH_FPU
-	if (last_task_used_math == tsk) {
+	if (last_task_used_math == tsk)
 		last_task_used_math = NULL;
-	}
 #endif
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

exit_thread-accept-a-task-parameter-to-be-exited.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

