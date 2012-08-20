From: akpm@linux-foundation.org
Subject: + fs-fat-fix-a-checkpatch-issue-in-namei_msdosc.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:23:22 -0700
Message-ID: <20120820202323.424C11E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:50658 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2HTUXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:23:25 -0400
Received: by ialo24 with SMTP id o24so910885ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:23:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs/fat: fix a checkpatch issue in namei_msdos.c
has been added to the -mm tree.  Its filename is
     fs-fat-fix-a-checkpatch-issue-in-namei_msdosc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-fat-fix-a-checkpatch-issue-in-namei_msdosc.patch
fs-fat-fix-some-checkpatch-issues-in-fath.patch
fs-fat-changed-indentation-of-some-comments-in-fath.patch
fs-fat-fix-two-checkpatch-issues-in-cachec.patch
fs-fat-fixes-some-small-checkpatch-issues-in-dirc.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fs-fat-fix-checkpatch-issues-in-fatentc.patch

