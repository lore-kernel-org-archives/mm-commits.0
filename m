From: akpm@linux-foundation.org
Subject: [merged] fs-fs-writebackc-fix-sync_inodes_sb-return-value-kernel-doc.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:11 -0800
Message-ID: <201101142252.p0EMq1iU005565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1ANWwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefanha@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fs/fs-writeback.c: fix sync_inodes_sb() return value kernel-doc
has been removed from the -mm tree.  Its filename was
     fs-fs-writebackc-fix-sync_inodes_sb-return-value-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/fs-writeback.c: fix sync_inodes_sb() return value kernel-doc
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

The sync_inodes_sb() function does not have a return value.  Remove the
outdated documentation comment.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~fs-fs-writebackc-fix-sync_inodes_sb-return-value-kernel-doc fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-fs-writebackc-fix-sync_inodes_sb-return-value-kernel-doc
+++ a/fs/fs-writeback.c
@@ -1225,7 +1225,7 @@ EXPORT_SYMBOL(writeback_inodes_sb_nr_if_
  * @sb: the superblock
  *
  * This function writes and waits on any dirty inode belonging to this
- * super_block. The number of pages synced is returned.
+ * super_block.
  */
 void sync_inodes_sb(struct super_block *sb)
 {
_

Patches currently in -mm which might be from stefanha@linux.vnet.ibm.com are

origin.patch

