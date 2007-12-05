From: akpm@linux-foundation.org
Subject: - ufs-fix-nexstep-dir-block-size-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 04 Dec 2007 23:33:49 -0800
Message-ID: <200712050733.lB57Xofc027024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbXLEHeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 02:34:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dsbailey@pacbell.net, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs-fix-nexstep-dir-block-size-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ufs-fix-nexstep-dir-block-size-checkpatch-fixes.patch

This patch was dropped because it was folded into ufs-fix-nexstep-dir-block-size.patch

------------------------------------------------------
Subject: ufs-fix-nexstep-dir-block-size-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: no space between function name and open parenthesis '('
#24: FILE: fs/ufs/dir.c:182:
+	ufs_error (sb, __FUNCTION__,

total: 0 errors, 1 warnings, 36 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Bailey <dsbailey@pacbell.net>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/dir.c~ufs-fix-nexstep-dir-block-size-checkpatch-fixes fs/ufs/dir.c
--- a/fs/ufs/dir.c~ufs-fix-nexstep-dir-block-size-checkpatch-fixes
+++ a/fs/ufs/dir.c
@@ -179,7 +179,7 @@ bad_entry:
 	goto fail;
 Eend:
 	p = (struct ufs_dir_entry *)(kaddr + offs);
-	ufs_error (sb, __FUNCTION__,
+	ufs_error(sb, __FUNCTION__,
 		   "entry in directory #%lu spans the page boundary"
 		   "offset=%lu",
 		   dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ufs-fix-nexstep-dir-block-size.patch
ufs-fix-nexstep-dir-block-size-checkpatch-fixes.patch
