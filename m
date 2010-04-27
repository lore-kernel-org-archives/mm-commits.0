From: akpm@linux-foundation.org
Subject: [folded] vfs-o_-bit-numbers-uniqueness-check-update.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:41:00 -0700
Message-ID: <201004271908.o3RJ8PhY014254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300Ab0D0TIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 15:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     vfs: O_* bit numbers uniqueness check
has been removed from the -mm tree.  Its filename was
     vfs-o_-bit-numbers-uniqueness-check-update.patch

This patch was dropped because it was folded into vfs-o_-bit-numbers-uniqueness-check.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: O_* bit numbers uniqueness check
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fcntl.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/fcntl.h~vfs-o_-bit-numbers-uniqueness-check-update include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~vfs-o_-bit-numbers-uniqueness-check-update
+++ a/include/asm-generic/fcntl.h
@@ -4,8 +4,6 @@
 #include <linux/types.h>
 
 /*
- * When introducing new O_* bits, please check its uniqueness in fcntl_init().
- *
  * FMODE_EXEC is 0x20
  * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
@@ -13,6 +11,10 @@
  * -Eric Paris
  */
 
+/*
+ * When introducing new O_* bits, please check its uniqueness in fcntl_init().
+ */
+
 #define O_ACCMODE	00000003
 #define O_RDONLY	00000000
 #define O_WRONLY	00000001
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-o_-bit-numbers-uniqueness-check-update.patch
vfs-o_-bit-numbers-uniqueness-check-fix.patch
vfs-o_-bit-numbers-uniqueness-check-fix-2.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vmscan-prevent-get_scan_ratio-rounding-errors.patch
readaheadc-fix-comment.patch
fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback.patch
vfs-add-super-operation-writeback_inodes.patch

