From: akpm@linux-foundation.org
Subject: [merged] fs-inode-fix-kernel-doc-format-for-inode_init_owner.patch removed from -mm tree
Date: Mon, 21 Mar 2011 12:16:28 -0700
Message-ID: <201103211919.p2LJJgFi020219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab1CUTUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 15:20:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/inode: fix kernel-doc format for inode_init_owner()
has been removed from the -mm tree.  Its filename was
     fs-inode-fix-kernel-doc-format-for-inode_init_owner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch

