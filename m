From: akpm@linux-foundation.org
Subject: [merged] fs-affs-remove-reference-to-affs_parent_ino.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:50:17 -0800
Message-ID: <58b5e289.OdVKbQ2B1AliaRDm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbdB1Uvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: remove reference to affs_parent_ino()
has been removed from the -mm tree.  Its filename was
     fs-affs-remove-reference-to-affs_parent_ino.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: remove reference to affs_parent_ino()

Patch series "make FS exportable plus some clean-up", v7.

This small patchset makes AFFS work with NFS for standard operations.


THis patch (of 7):

affs_parent_ino() was removed a long time ago.

Link: http://lkml.kernel.org/r/20170109191208.6085-2-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/affs/affs.h~fs-affs-remove-reference-to-affs_parent_ino fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-remove-reference-to-affs_parent_ino
+++ a/fs/affs/affs.h
@@ -178,7 +178,6 @@ extern int	affs_rename(struct inode *old
 
 /* inode.c */
 
-extern unsigned long		 affs_parent_ino(struct inode *dir);
 extern struct inode		*affs_new_inode(struct inode *dir);
 extern int			 affs_notify_change(struct dentry *dentry, struct iattr *attr);
 extern void			 affs_evict_inode(struct inode *inode);
_

Patches currently in -mm which might be from fabf@skynet.be are


