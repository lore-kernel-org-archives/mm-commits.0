From: akpm@linux-foundation.org
Subject: + fs-ecryptfs-inodec-cleanup-kerneldoc.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:42:20 -0800
Message-ID: <200811122242.mACMgKXH032208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYKLWnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:43:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, mhalcrow@us.ibm.com, randy.dunlap@oracle.com


The patch titled
     fs/ecryptfs/inode.c: cleanup kerneldoc
has been added to the -mm tree.  Its filename is
     fs-ecryptfs-inodec-cleanup-kerneldoc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch

