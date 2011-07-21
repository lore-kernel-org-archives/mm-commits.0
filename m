From: akpm@linux-foundation.org
Subject: [merged] debugfs-fix-documentation.patch removed from -mm tree
Date: Thu, 21 Jul 2011 12:12:34 -0700
Message-ID: <201107211912.p6LJCRIE032254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1GUTMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 15:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     debugfs: fix documentation
has been removed from the -mm tree.  Its filename was
     debugfs-fix-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: debugfs: fix documentation
From: Akinobu Mita <akinobu.mita@gmail.com>

debugfs_create_x64() exists.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/debugfs.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/debugfs.txt~debugfs-fix-documentation Documentation/filesystems/debugfs.txt
--- a/Documentation/filesystems/debugfs.txt~debugfs-fix-documentation
+++ a/Documentation/filesystems/debugfs.txt
@@ -73,8 +73,8 @@ the following functions can be used inst
 				      struct dentry *parent, u16 *value);
     struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				      struct dentry *parent, u32 *value);
-
-Note that there is no debugfs_create_x64().
+    struct dentry *debugfs_create_x64(const char *name, mode_t mode,
+				      struct dentry *parent, u64 *value);
 
 These functions are useful as long as the developer knows the size of the
 value to be exported.  Some types can have different widths on different
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
fault-injection-do-not-include-unneeded-header.patch
fault-injection-remove-nonexistent-function-extern.patch
fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch
fault-injection-use-debugfs_remove_recursive.patch
failslab-simplify-debugfs-initialization.patch
fail_page_alloc-simplify-debugfs-initialization.patch
fail_make_request-cleanup-should_fail_request.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

