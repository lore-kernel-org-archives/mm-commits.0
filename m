From: akpm@osdl.org
Subject: - struct-path-convert-oprofile.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:30 -0800
Message-ID: <200612082004.kB8K4UVp002187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426291AbWLHUEe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert oprofile
has been removed from the -mm tree.  Its filename was
     struct-path-convert-oprofile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert oprofile
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/oprofile/buffer_sync.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/oprofile/buffer_sync.c~struct-path-convert-oprofile drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~struct-path-convert-oprofile
+++ a/drivers/oprofile/buffer_sync.c
@@ -220,8 +220,8 @@ static unsigned long get_exec_dcookie(st
 			continue;
 		if (!(vma->vm_flags & VM_EXECUTABLE))
 			continue;
-		cookie = fast_get_dcookie(vma->vm_file->f_dentry,
-			vma->vm_file->f_vfsmnt);
+		cookie = fast_get_dcookie(vma->vm_file->f_path.dentry,
+			vma->vm_file->f_path.mnt);
 		break;
 	}
 
@@ -246,8 +246,8 @@ static unsigned long lookup_dcookie(stru
 			continue;
 
 		if (vma->vm_file) {
-			cookie = fast_get_dcookie(vma->vm_file->f_dentry,
-				vma->vm_file->f_vfsmnt);
+			cookie = fast_get_dcookie(vma->vm_file->f_path.dentry,
+				vma->vm_file->f_path.mnt);
 			*offset = (vma->vm_pgoff << PAGE_SHIFT) + addr -
 				vma->vm_start;
 		} else {
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

