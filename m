From: akpm@linux-foundation.org
Subject: + fs-fs-writebackc-fix-sync_inodes_sb-return-value-kernel-doc.patch added to -mm tree
Date: Tue, 04 Jan 2011 17:00:15 -0800
Message-ID: <201101050100.p0510FBv001763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab1AEBA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 20:00:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefanha@linux.vnet.ibm.com


The patch titled
     fs/fs-writeback.c: fix sync_inodes_sb() return value kernel-doc
has been added to the -mm tree.  Its filename is
     fs-fs-writebackc-fix-sync_inodes_sb-return-value-kernel-doc.patch

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
@@ -1247,7 +1247,7 @@ EXPORT_SYMBOL(writeback_inodes_sb_nr_if_
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

fs-fs-writebackc-fix-sync_inodes_sb-return-value-kernel-doc.patch

