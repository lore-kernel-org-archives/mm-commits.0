From: akpm@osdl.org
Subject: - struct-path-convert-romfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:48 -0800
Message-ID: <200612082004.kB8K4m7a002232@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57395 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426304AbWLHUEw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert romfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-romfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert romfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/romfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/romfs/inode.c~struct-path-convert-romfs fs/romfs/inode.c
--- a/fs/romfs/inode.c~struct-path-convert-romfs
+++ a/fs/romfs/inode.c
@@ -276,7 +276,7 @@ static unsigned char romfs_dtype_table[]
 static int
 romfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct inode *i = filp->f_dentry->d_inode;
+	struct inode *i = filp->f_path.dentry->d_inode;
 	struct romfs_inode ri;
 	unsigned long offset, maxoff;
 	int j, ino, nextfh;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

