From: akpm@linux-foundation.org
Subject: + ufs-remove-unneeded-ufs_put_inode-prototype.patch added to -mm tree
Date: Tue, 06 May 2008 12:32:08 -0700
Message-ID: <200805061932.m46JW8sw023444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757144AbYEFTcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:32:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, dushistov@mail.ru


The patch titled
     ufs: remove unneeded ufs_put_inode prototype
has been added to the -mm tree.  Its filename is
     ufs-remove-unneeded-ufs_put_inode-prototype.patch

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

linux-next.patch
git-cifs.patch
git-unionfs.patch
ufs-remove-unneeded-ufs_put_inode-prototype.patch

