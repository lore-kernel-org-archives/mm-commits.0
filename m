From: akpm@linux-foundation.org
Subject: - devcgroup-remove-unused-variable.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:24 -0700
Message-ID: <200810202036.m9KKaOws011365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227AbYJTUqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devcgroup: remove unused variable
has been removed from the -mm tree.  Its filename was
     devcgroup-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: remove unused variable
From: Li Zefan <lizf@cn.fujitsu.com>

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-remove-unused-variable security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-remove-unused-variable
+++ a/security/device_cgroup.c
@@ -355,7 +355,7 @@ static int devcgroup_update_access(struc
 	struct dev_cgroup *cur_devcgroup;
 	const char *b;
 	char *endp;
-	int retval = 0, count;
+	int count;
 	struct dev_whitelist_item wh;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -432,7 +432,6 @@ static int devcgroup_update_access(struc
 	}
 
 handle:
-	retval = 0;
 	switch (filetype) {
 	case DEVCG_ALLOW:
 		if (!parent_has_perm(devcgroup, &wh))
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

