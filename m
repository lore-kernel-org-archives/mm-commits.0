From: akpm@linux-foundation.org
Subject: [folded-merged]
 writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch removed
 from -mm tree
Date: Tue, 12 Nov 2013 14:35:45 -0800
Message-ID: <5282ad41.ZeDiK/v8L5ZyNcLQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3KLWfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:35:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz

Subject: [folded-merged] writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch removed from -mm tree
To: jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:35:45 -0800


The patch titled
     Subject: writeback-do-not-sync-data-dirtied-after-sync-start-fix-3
has been removed from the -mm tree.  Its filename was
     writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch

This patch was dropped because it was folded into writeback-do-not-sync-data-dirtied-after-sync-start.patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback-do-not-sync-data-dirtied-after-sync-start-fix-3

Fixup sync_inodes_sb() comment

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start-fix-3 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start-fix-3
+++ a/fs/fs-writeback.c
@@ -1353,10 +1353,11 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb
 
 /**
  * sync_inodes_sb	-	sync sb inode pages
- * @sb: the superblock
+ * @sb:			the superblock
+ * @older_than_this:	timestamp
  *
  * This function writes and waits on any dirty inode belonging to this
- * super_block.
+ * superblock that has been dirtied before given timestamp.
  */
 void sync_inodes_sb(struct super_block *sb, unsigned long older_than_this)
 {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ocfs2-dont-spam-on-edquot.patch
ocfs2-simplify-ocfs2_invalidatepage-and-ocfs2_releasepage.patch
writeback-do-not-sync-data-dirtied-after-sync-start.patch
rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch

