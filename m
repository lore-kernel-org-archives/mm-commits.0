From: akpm@linux-foundation.org
Subject: - ext2-fix-ext2_splice_branch-comments.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:50 -0800
Message-ID: <200901082246.n08Mko6R026351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757042AbZAHWrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:47:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ext2: fix ext2_splice_branch() comments
has been removed from the -mm tree.  Its filename was
     ext2-fix-ext2_splice_branch-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -498,8 +498,6 @@ static int ext2_alloc_branch(struct inod
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

origin.patch
linux-next.patch

