From: akpm@linux-foundation.org
Subject: - bsdacct-truthify-a-comment-near-acct_process.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:53 -0700
Message-ID: <200807252302.m6PN2rZw003864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbYGYXDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     bsdacct: "truthify" a comment near acct_process
has been removed from the -mm tree.  Its filename was
     bsdacct-truthify-a-comment-near-acct_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: "truthify" a comment near acct_process
From: Pavel Emelyanov <xemul@openvz.org>

The acct_process does not accept any arguments actually.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/acct.c~bsdacct-truthify-a-comment-near-acct_process kernel/acct.c
--- a/kernel/acct.c~bsdacct-truthify-a-comment-near-acct_process
+++ a/kernel/acct.c
@@ -579,7 +579,6 @@ void acct_collect(long exitcode, int gro
 
 /**
  * acct_process - now just a wrapper around do_acct_process
- * @exitcode: task exit code
  *
  * handles process accounting for an exiting task
  */
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

