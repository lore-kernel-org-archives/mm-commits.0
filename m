From: akpm@linux-foundation.org
Subject: [merged] vfs-delete-vfs_readdir-function-declaration.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:10 -0700
Message-ID: <552fe87e./XfO6il30j7J9r/+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbDPQpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: delete vfs_readdir function declaration
has been removed from the -mm tree.  Its filename was
     vfs-delete-vfs_readdir-function-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: vfs: delete vfs_readdir function declaration

vfs_readdir() was replaced by iterate_dir() in 5c0ba4e0762e6da ("[readdir]
introduce iterate_dir() and dir_context").

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/fs.h~vfs-delete-vfs_readdir-function-declaration include/linux/fs.h
--- a/include/linux/fs.h~vfs-delete-vfs_readdir-function-declaration
+++ a/include/linux/fs.h
@@ -2684,7 +2684,6 @@ void inode_sub_bytes(struct inode *inode
 loff_t inode_get_bytes(struct inode *inode);
 void inode_set_bytes(struct inode *inode, loff_t bytes);
 
-extern int vfs_readdir(struct file *, filldir_t, void *);
 extern int iterate_dir(struct file *, struct dir_context *);
 
 extern int vfs_stat(const char __user *, struct kstat *);
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

origin.patch

