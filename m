From: akpm@linux-foundation.org
Subject: [merged] fs-romfs-superc-add-blank-line-after-declarations.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:14 -0700
Message-ID: <53ea6dda.oYeotOnhMMieQtKh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:56489 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaHLTlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:15 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1916447obb.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/romfs/super.c: add blank line after declarations
has been removed from the -mm tree.  Its filename was
     fs-romfs-superc-add-blank-line-after-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/romfs/super.c: add blank line after declarations

Fix checkpatch warning:
"WARNING: Missing a blank line after declarations"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/romfs/super.c~fs-romfs-superc-add-blank-line-after-declarations fs/romfs/super.c
--- a/fs/romfs/super.c~fs-romfs-superc-add-blank-line-after-declarations
+++ a/fs/romfs/super.c
@@ -392,6 +392,7 @@ error:
 static struct inode *romfs_alloc_inode(struct super_block *sb)
 {
 	struct romfs_inode_info *inode;
+
 	inode = kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
 	return inode ? &inode->vfs_inode : NULL;
 }
@@ -402,6 +403,7 @@ static struct inode *romfs_alloc_inode(s
 static void romfs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
+
 	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
 }
 
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

