From: akpm@linux-foundation.org
Subject: - ext2-add-explicit-include-of-linux-quotah-into-superc.patch removed from -mm tree
Date: Thu, 05 Jun 2008 11:48:43 -0700
Message-ID: <200806051848.m55Imh8M024388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYFESsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext2: add explicit include of <linux/quota.h> into super.c
has been removed from the -mm tree.  Its filename was
     ext2-add-explicit-include-of-linux-quotah-into-superc.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: add explicit include of <linux/quota.h> into super.c
From: Jan Kara <jack@suse.cz>

We need definitions from quota.h and so far we depended on fs.h to include
this file for us.  This will be no longer true.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ext2/super.c~ext2-add-explicit-include-of-linux-quotah-into-superc fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-add-explicit-include-of-linux-quotah-into-superc
+++ a/fs/ext2/super.c
@@ -31,6 +31,7 @@
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/log2.h>
+#include <linux/quota.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
jbd-strictly-check-for-write-errors-on-data-buffers.patch
jbd-ordered-data-integrity-fix.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-abort-ext3-if-the-journal-has-aborted.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline.patch
quota-cleanup-loop-in-sync_dquots.patch
ext2-add-explicit-include-of-linux-quotah-into-superc.patch
quota-split-out-quota_structh-out-of-quotah.patch
quota-convert-macros-to-inline-functions.patch

