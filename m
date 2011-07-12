From: akpm@linux-foundation.org
Subject: + debugfs-fix-documentation.patch added to -mm tree
Date: Tue, 12 Jul 2011 15:25:25 -0700
Message-ID: <201107122225.p6CMPPI1007389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932120Ab1GLWZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 18:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de


The patch titled
     debugfs: fix documentation
has been added to the -mm tree.  Its filename is
     debugfs-fix-documentation.patch

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

fs-libfsc-fix-simple_attr_write-on-32bit-machines.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
debugfs-fix-documentation.patch
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

