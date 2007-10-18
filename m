From: akpm@linux-foundation.org
Subject: - fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:53:37 -0700
Message-ID: <200710180853.l9I8rbpE003046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49747 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754861AbXJRIx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jakub.bogusz@gemius.pl, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse-fix-race-between-getattr-and-write-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch

This patch was dropped because it was folded into fuse-fix-race-between-getattr-and-write.patch

------------------------------------------------------
Subject: fuse-fix-race-between-getattr-and-write-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#267: FILE: fs/fuse/dir.c:851:
+^I^I ^I$

Cc: Jakub Bogusz <jakub.bogusz@gemius.pl>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/dir.c~fuse-fix-race-between-getattr-and-write-checkpatch-fixes fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-race-between-getattr-and-write-checkpatch-fixes
+++ a/fs/fuse/dir.c
@@ -848,7 +848,7 @@ static int fuse_permission(struct inode 
 		   attributes.  This is also needed, because the root
 		   node will at first have no permissions */
 		if (err == -EACCES && !refreshed) {
-		 	err = fuse_do_getattr(inode, NULL);
+			err = fuse_do_getattr(inode, NULL);
 			if (!err)
 				err = generic_permission(inode, mask, NULL);
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
