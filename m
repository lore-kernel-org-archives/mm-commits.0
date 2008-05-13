From: akpm@linux-foundation.org
Subject: - ufs-remove-unneeded-ufs_put_inode-prototype.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:12 -0700
Message-ID: <200805132133.m4DLXCxL000795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761626AbYEMVda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: remove unneeded ufs_put_inode prototype
has been removed from the -mm tree.  Its filename was
     ufs-remove-unneeded-ufs_put_inode-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: remove unneeded ufs_put_inode prototype
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/ufs.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ufs/ufs.h~ufs-remove-unneeded-ufs_put_inode-prototype fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~ufs-remove-unneeded-ufs_put_inode-prototype
+++ a/fs/ufs/ufs.h
@@ -107,7 +107,6 @@ extern struct inode * ufs_new_inode (str
 
 /* inode.c */
 extern struct inode *ufs_iget(struct super_block *, unsigned long);
-extern void ufs_put_inode (struct inode *);
 extern int ufs_write_inode (struct inode *, int);
 extern int ufs_sync_inode (struct inode *);
 extern void ufs_delete_inode (struct inode *);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
git-unionfs.patch
kill-generic_file_direct_io.patch
kill-generic_file_direct_io-checkpatch-fixes.patch

