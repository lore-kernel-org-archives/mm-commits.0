From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 20 Dec 2016 13:14:56 -0800
Message-ID: <58599f50.rMKnfWHfkXCI8lkI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755510AbcLTVO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 16:14:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota/dquot.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/quota/dquot.c~linux-next-git-rejects fs/quota/dquot.c
--- a/fs/quota/dquot.c~linux-next-git-rejects
+++ a/fs/quota/dquot.c
@@ -2184,13 +2184,8 @@ int dquot_disable(struct super_block *sb
 	 * must also discard the blockdev buffers so that we see the
 	 * changes done by userspace on the next quotaon() */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-<<<<<<< HEAD
-		/* This can happen when suspending quotas on remount-ro... */
-		if (toputinode[cnt] && !sb_has_quota_loaded(sb, cnt)) {
-=======
 		if (toputinode[cnt]) {
 			WARN_ON_ONCE(sb_has_quota_loaded(sb, cnt));
->>>>>>> linux-next/akpm-base
 			inode_lock(toputinode[cnt]);
 			toputinode[cnt]->i_flags &= ~(S_IMMUTABLE |
 				  S_NOATIME | S_NOQUOTA);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

