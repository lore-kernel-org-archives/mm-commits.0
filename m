From: akpm@linux-foundation.org
Subject: + fs-inode-fix-kernel-doc-format-for-inode_init_owner.patch added to -mm tree
Date: Mon, 28 Feb 2011 15:08:39 -0800
Message-ID: <201102282308.p1SN8dGl002991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab1B1XIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 18:08:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk


The patch titled
     fs/inode: fix kernel-doc format for inode_init_owner()
has been added to the -mm tree.  Its filename is
     fs-inode-fix-kernel-doc-format-for-inode_init_owner.patch

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
Subject: fs/inode: fix kernel-doc format for inode_init_owner()
From: Ben Hutchings <ben@decadent.org.uk>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/inode.c~fs-inode-fix-kernel-doc-format-for-inode_init_owner fs/inode.c
--- a/fs/inode.c~fs-inode-fix-kernel-doc-format-for-inode_init_owner
+++ a/fs/inode.c
@@ -1719,7 +1719,7 @@ void init_special_inode(struct inode *in
 EXPORT_SYMBOL(init_special_inode);
 
 /**
- * Init uid,gid,mode for new inode according to posix standards
+ * inode_init_owner - Init uid,gid,mode for new inode according to posix standards
  * @inode: New inode
  * @dir: Directory inode
  * @mode: mode of the new inode
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
block-fix-kernel-doc-format-for-blkdev_issue_zeroout.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
fs-inode-fix-kernel-doc-format-for-inode_init_owner.patch

