From: akpm@linux-foundation.org
Subject: + efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch added to -mm tree
Date: Tue, 01 Apr 2008 13:23:52 -0700
Message-ID: <200804012023.m31KNq5x011525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758031AbYDAUYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 16:24:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     efs: update error msg to not refer to deleted read_inode()
has been added to the -mm tree.  Its filename is
     efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch
git-powerpc.patch
git-ieee1394.patch
git-infiniband.patch
mmc-use-shorter-equivalent-set_current_state.patch
git-net.patch
lapb-use-the-shorter-list_head-form-for-brevity.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
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
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch

