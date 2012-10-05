From: akpm@linux-foundation.org
Subject: [merged] fs-fat-fix-a-checkpatch-issue-in-namei_msdosc.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:21 -0700
Message-ID: <20121005201821.A04B3100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49795 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2JEUSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:22 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236299ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: fix a checkpatch issue in namei_msdos.c
has been removed from the -mm tree.  Its filename was
     fs-fat-fix-a-checkpatch-issue-in-namei_msdosc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: fs/fat: fix a checkpatch issue in namei_msdos.c

Add a space before an equals sign/operator in line 410.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_msdos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/namei_msdos.c~fs-fat-fix-a-checkpatch-issue-in-namei_msdosc fs/fat/namei_msdos.c
--- a/fs/fat/namei_msdos.c~fs-fat-fix-a-checkpatch-issue-in-namei_msdosc
+++ a/fs/fat/namei_msdos.c
@@ -407,7 +407,7 @@ out:
 static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	struct super_block *sb= inode->i_sb;
+	struct super_block *sb = inode->i_sb;
 	struct fat_slot_info sinfo;
 	int err;
 
_

Patches currently in -mm which might be from cruzjbishop@gmail.com are

origin.patch

