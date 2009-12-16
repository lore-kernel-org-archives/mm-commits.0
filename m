From: akpm@linux-foundation.org
Subject: [folded] ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:34:42 -0800
Message-ID: <200912160034.nBG0YgnU023669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761439AbZLPAfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:35:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch

This patch was dropped because it was folded into ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#18: FILE: fs/ext2/super.c:1092:
+static void ext2_clear_super_error(struct super_block * sb)

total: 1 errors, 0 warnings, 37 lines checked

./patches/ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/super.c~ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes
+++ a/fs/ext2/super.c
@@ -1105,7 +1105,7 @@ failed_sbi:
 	return ret;
 }
 
-static void ext2_clear_super_error(struct super_block * sb)
+static void ext2_clear_super_error(struct super_block *sb)
 {
 	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch

