From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-inodec-kernel-doc-warning-fixes.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:39:32 -0700
Message-ID: <53ea6d74.1m/jLUDj7E6aheQn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52744 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaHLTjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:33 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1917096obc.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs/inode.c: kernel-doc warning fixes
has been removed from the -mm tree.  Its filename was
     fs-ufs-inodec-kernel-doc-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/inode.c: kernel-doc warning fixes

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/ufs/inode.c~fs-ufs-inodec-kernel-doc-warning-fixes fs/ufs/inode.c
--- a/fs/ufs/inode.c~fs-ufs-inodec-kernel-doc-warning-fixes
+++ a/fs/ufs/inode.c
@@ -158,16 +158,16 @@ out:
 
 /**
  * ufs_inode_getfrag() - allocate new fragment(s)
- * @inode - pointer to inode
- * @fragment - number of `fragment' which hold pointer
+ * @inode: pointer to inode
+ * @fragment: number of `fragment' which hold pointer
  *   to new allocated fragment(s)
- * @new_fragment - number of new allocated fragment(s)
- * @required - how many fragment(s) we require
- * @err - we set it if something wrong
- * @phys - pointer to where we save physical number of new allocated fragments,
+ * @new_fragment: number of new allocated fragment(s)
+ * @required: how many fragment(s) we require
+ * @err: we set it if something wrong
+ * @phys: pointer to where we save physical number of new allocated fragments,
  *   NULL if we allocate not data(indirect blocks for example).
- * @new - we set it if we allocate new block
- * @locked_page - for ufs_new_fragments()
+ * @new: we set it if we allocate new block
+ * @locked_page: for ufs_new_fragments()
  */
 static struct buffer_head *
 ufs_inode_getfrag(struct inode *inode, u64 fragment,
@@ -315,16 +315,16 @@ repeat2:
 
 /**
  * ufs_inode_getblock() - allocate new block
- * @inode - pointer to inode
- * @bh - pointer to block which hold "pointer" to new allocated block
- * @fragment - number of `fragment' which hold pointer
+ * @inode: pointer to inode
+ * @bh: pointer to block which hold "pointer" to new allocated block
+ * @fragment: number of `fragment' which hold pointer
  *   to new allocated block
- * @new_fragment - number of new allocated fragment
+ * @new_fragment: number of new allocated fragment
  *  (block will hold this fragment and also uspi->s_fpb-1)
- * @err - see ufs_inode_getfrag()
- * @phys - see ufs_inode_getfrag()
- * @new - see ufs_inode_getfrag()
- * @locked_page - see ufs_inode_getfrag()
+ * @err: see ufs_inode_getfrag()
+ * @phys: see ufs_inode_getfrag()
+ * @new: see ufs_inode_getfrag()
+ * @locked_page: see ufs_inode_getfrag()
  */
 static struct buffer_head *
 ufs_inode_getblock(struct inode *inode, struct buffer_head *bh,
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

