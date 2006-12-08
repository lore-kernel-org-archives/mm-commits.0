From: akpm@osdl.org
Subject: - struct-path-convert-minix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:04 -0800
Message-ID: <200612082004.kB8K448Q002142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426273AbWLHUEL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert minix
has been removed from the -mm tree.  Its filename was
     struct-path-convert-minix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert minix
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/minix/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/dir.c~struct-path-convert-minix fs/minix/dir.c
--- a/fs/minix/dir.c~struct-path-convert-minix
+++ a/fs/minix/dir.c
@@ -82,7 +82,7 @@ static inline void *minix_next_entry(voi
 static int minix_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	unsigned long pos = filp->f_pos;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
 	unsigned offset = pos & ~PAGE_CACHE_MASK;
 	unsigned long n = pos >> PAGE_CACHE_SHIFT;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-minix.patch
struct-path-convert-mips.patch
struct-path-convert-mm.patch
struct-path-convert-nbd.patch
struct-path-convert-ncpfs.patch
struct-path-convert-net.patch
struct-path-convert-netfilter.patch
struct-path-convert-netlink.patch
struct-path-convert-ocfs2.patch
struct-path-convert-openpromfs.patch
struct-path-convert-oprofile.patch
struct-path-convert-parisc.patch
struct-path-convert-pci.patch
struct-path-convert-pcmcia.patch
struct-path-convert-powerpc.patch
struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
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

