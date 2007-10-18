From: akpm@linux-foundation.org
Subject: - fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:56:26 -0700
Message-ID: <200710180856.l9I8uQSd003114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932614AbXJRI5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse-add-file-handle-to-getattr-operation-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch

This patch was dropped because it was folded into fuse-add-file-handle-to-getattr-operation.patch

------------------------------------------------------
Subject: fuse-add-file-handle-to-getattr-operation-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#88: FILE: fs/fuse/dir.c:864:
+^I^I ^I$

Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/dir.c~fuse-add-file-handle-to-getattr-operation-checkpatch-fixes fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-file-handle-to-getattr-operation-checkpatch-fixes
+++ a/fs/fuse/dir.c
@@ -861,7 +861,7 @@ static int fuse_permission(struct inode 
 		   attributes.  This is also needed, because the root
 		   node will at first have no permissions */
 		if (err == -EACCES && !refreshed) {
-		 	err = fuse_do_getattr(inode, NULL, NULL);
+			err = fuse_do_getattr(inode, NULL, NULL);
 			if (!err)
 				err = generic_permission(inode, mask, NULL);
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-add-file-handle-to-getattr-operation.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
