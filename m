From: akpm@linux-foundation.org
Subject: - efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:06 -0700
Message-ID: <200804041900.m34J06o7004248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbYDDTAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     efs: update error msg to not refer to deleted read_inode()
has been removed from the -mm tree.  Its filename was
     efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: efs: update error msg to not refer to deleted read_inode()
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/efs/inode.c~efs-update-error-msg-to-not-refer-to-deleted-read_inode fs/efs/inode.c
--- a/fs/efs/inode.c~efs-update-error-msg-to-not-refer-to-deleted-read_inode
+++ a/fs/efs/inode.c
@@ -140,7 +140,7 @@ struct inode *efs_iget(struct super_bloc
 	brelse(bh);
    
 #ifdef DEBUG
-	printk(KERN_DEBUG "EFS: read_inode(): inode %lu, extents %d, mode %o\n",
+	printk(KERN_DEBUG "EFS: efs_iget(): inode %lu, extents %d, mode %o\n",
 		inode->i_ino, in->numextents, inode->i_mode);
 #endif
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-powerpc.patch
git-ieee1394.patch
git-infiniband.patch
mmc-use-shorter-equivalent-set_current_state.patch
git-net.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
mfd-use-shorter-set_current_state.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

