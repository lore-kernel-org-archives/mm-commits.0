From: akpm@linux-foundation.org
Subject: - fs-ecryptfs-inodec-cleanup-kerneldoc.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:37 -0800
Message-ID: <200901072218.n07MIb9h018049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762186AbZAGWTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, mhalcrow@us.ibm.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/ecryptfs/inode.c: cleanup kerneldoc
has been removed from the -mm tree.  Its filename was
     fs-ecryptfs-inodec-cleanup-kerneldoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ecryptfs/inode.c: cleanup kerneldoc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

Arguments lower_dentry and ecryptfs_dentry in ecryptfs_create_underlying_file()
have been merged into dentry, now fix it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~fs-ecryptfs-inodec-cleanup-kerneldoc fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~fs-ecryptfs-inodec-cleanup-kerneldoc
+++ a/fs/ecryptfs/inode.c
@@ -52,8 +52,7 @@ static void unlock_dir(struct dentry *di
 /**
  * ecryptfs_create_underlying_file
  * @lower_dir_inode: inode of the parent in the lower fs of the new file
- * @lower_dentry: New file's dentry in the lower fs
- * @ecryptfs_dentry: New file's dentry in ecryptfs
+ * @dentry: New file's dentry
  * @mode: The mode of the new file
  * @nd: nameidata of ecryptfs' parent's dentry & vfsmount
  *
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
linux-next.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

