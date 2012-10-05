From: akpm@linux-foundation.org
Subject: [merged] fs-fat-fix-some-checkpatch-issues-in-fath.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:24 -0700
Message-ID: <20121005201824.A3036100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50910 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2JEUSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:25 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236805vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: fix some checkpatch issues in fat.h
has been removed from the -mm tree.  Its filename was
     fs-fat-fix-some-checkpatch-issues-in-fath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

