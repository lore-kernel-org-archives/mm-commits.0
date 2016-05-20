From: akpm@linux-foundation.org
Subject: [folded-merged]
 procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch removed
 from -mm tree
Date: Fri, 20 May 2016 16:43:19 -0700
Message-ID: <573fa117.sCbvge1/TaV+h2DE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbcETXnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jdanis@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix
has been removed from the -mm tree.  Its filename was
     procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch

This patch was dropped because it was folded into procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix

fix spello in comment

Cc: Janis Danisevskis <jdanis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix fs/proc/base.c
--- a/fs/proc/base.c~procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix
+++ a/fs/proc/base.c
@@ -3167,7 +3167,7 @@ int proc_pid_readdir(struct file *file,
  * used for the node /proc/<pid>/task/<tid>/comm.
  * It bypasses generic permission checks in the case where a task of the same
  * task group attempts to access the node.
- * The rational behind this is that glibc and bionic access this node for
+ * The rationale behind this is that glibc and bionic access this node for
  * cross thread naming (pthread_set/getname_np(!self)). However, if
  * PR_SET_DUMPABLE gets set to 0 this node among others becomes uid=0 gid=0,
  * which locks out the cross thread naming implementation.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

