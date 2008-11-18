From: akpm@linux-foundation.org
Subject: + ext2-fix-ext2_splice_branch-comments.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:20:18 -0800
Message-ID: <200811182320.mAINKIEu020274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYKRXUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:20:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com


The patch titled
     ext2: fix ext2_splice_branch() comments
has been added to the -mm tree.  Its filename is
     ext2-fix-ext2_splice_branch-comments.patch

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
Subject: ext2: fix ext2_splice_branch() comments
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

There is no argument named @chain in ext2_splice_branch, remove references
to it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ext2/inode.c~ext2-fix-ext2_splice_branch-comments fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-fix-ext2_splice_branch-comments
+++ a/fs/ext2/inode.c
@@ -497,8 +497,6 @@ static int ext2_alloc_branch(struct inod
  * ext2_splice_branch - splice the allocated branch onto inode.
  * @inode: owner
  * @block: (logical) number of block we are adding
- * @chain: chain of indirect blocks (with a missing link - see
- *	ext2_alloc_branch)
  * @where: location of missing link
  * @num:   number of indirect blocks we are adding
  * @blks:  number of direct blocks we are adding
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

linux-next.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

