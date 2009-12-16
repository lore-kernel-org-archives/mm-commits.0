From: akpm@linux-foundation.org
Subject: [folded] ipc-remove-unreachable-code-in-semc-fix.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:36:42 -0800
Message-ID: <200912160036.nBG0agiH023797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761449AbZLPAhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:37:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amwang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ipc-remove-unreachable-code-in-semc-fix
has been removed from the -mm tree.  Its filename was
     ipc-remove-unreachable-code-in-semc-fix.patch

This patch was dropped because it was folded into ipc-remove-unreachable-code-in-semc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-remove-unreachable-code-in-semc-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Amerigo Wang <amwang@redhat.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-remove-unreachable-code-in-semc-fix ipc/sem.c
--- a/ipc/sem.c~ipc-remove-unreachable-code-in-semc-fix
+++ a/ipc/sem.c
@@ -624,7 +624,7 @@ static unsigned long copy_semid_to_user(
 static int semctl_nolock(struct ipc_namespace *ns, int semid,
 			 int cmd, int version, union semun arg)
 {
-	int err = -EINVAL;
+	int err;
 	struct sem_array *sma;
 
 	switch(cmd) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch
ipc-remove-unreachable-code-in-semc.patch
ipc-remove-unreachable-code-in-semc-fix.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch

