From: akpm@osdl.org
Subject: - struct-path-convert-parisc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:32 -0800
Message-ID: <200612082004.kB8K4W00002190@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57347 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426295AbWLHUEg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert parisc
has been removed from the -mm tree.  Its filename was
     struct-path-convert-parisc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert parisc
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/parisc/hpux/sys_hpux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/hpux/sys_hpux.c~struct-path-convert-parisc arch/parisc/hpux/sys_hpux.c
--- a/arch/parisc/hpux/sys_hpux.c~struct-path-convert-parisc
+++ a/arch/parisc/hpux/sys_hpux.c
@@ -237,7 +237,7 @@ asmlinkage long hpux_fstatfs(unsigned in
 	file = fget(fd);
 	if (!file)
 		goto out;
-	error = vfs_statfs_hpux(file->f_dentry, &tmp);
+	error = vfs_statfs_hpux(file->f_path.dentry, &tmp);
 	if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 		error = -EFAULT;
 	fput(file);
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

