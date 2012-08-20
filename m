From: akpm@linux-foundation.org
Subject: + fs-fat-fix-some-checkpatch-issues-in-fath.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:23:25 -0700
Message-ID: <20120820202326.9ED1A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35981 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2HTUX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:23:29 -0400
Received: by lbbge1 with SMTP id ge1so314618lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:23:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs/fat: fix some checkpatch issues in fat.h
has been added to the -mm tree.  Its filename is
     fs-fat-fix-some-checkpatch-issues-in-fath.patch

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
Subject: fs/fat: fix some checkpatch issues in fat.h

Mainly fix spacing issues such as "foo * bar" and "foo= bar"

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/fat/fat.h~fs-fat-fix-some-checkpatch-issues-in-fath fs/fat/fat.h
--- a/fs/fat/fat.h~fs-fat-fix-some-checkpatch-issues-in-fath
+++ a/fs/fat/fat.h
@@ -61,7 +61,7 @@ struct msdos_sb_info {
 	unsigned short sec_per_clus; /* sectors/cluster */
 	unsigned short cluster_bits; /* log2(cluster_size) */
 	unsigned int cluster_size;   /* cluster size */
-	unsigned char fats,fat_bits; /* number of FATs, FAT bits (12 or 16) */
+	unsigned char fats, fat_bits; /* number of FATs, FAT bits (12 or 16) */
 	unsigned short fat_start;
 	unsigned long fat_length;    /* FAT start & length (sec.) */
 	unsigned long dir_start;
@@ -328,7 +328,7 @@ extern long fat_generic_ioctl(struct fil
 			      unsigned long arg);
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
-extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
+extern int fat_setattr(struct dentry *dentry, struct iattr *attr);
 extern void fat_truncate_blocks(struct inode *inode, loff_t offset);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
@@ -346,7 +346,7 @@ extern int fat_fill_super(struct super_b
 			  int isvfat, void (*setup)(struct super_block *));
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
-		            struct inode *i2);
+			    struct inode *i2);
 static inline unsigned long fat_dir_hash(int logstart)
 {
 	return hash_32(logstart, FAT_HASH_BITS);
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

