From: akpm@osdl.org
Subject: - struct-path-convert-alpha.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:29 -0800
Message-ID: <200612082002.kB8K2Tc9001981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57034 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426237AbWLHUCg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert alpha
has been removed from the -mm tree.  Its filename was
     struct-path-convert-alpha.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert alpha
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/alpha/kernel/osf_sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/kernel/osf_sys.c~struct-path-convert-alpha arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~struct-path-convert-alpha
+++ a/arch/alpha/kernel/osf_sys.c
@@ -277,7 +277,7 @@ osf_fstatfs(unsigned long fd, struct osf
 	retval = -EBADF;
 	file = fget(fd);
 	if (file) {
-		retval = do_osf_statfs(file->f_dentry, buffer, bufsiz);
+		retval = do_osf_statfs(file->f_path.dentry, buffer, bufsiz);
 		fput(file);
 	}
 	return retval;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-alpha.patch
struct-path-convert-atm.patch
struct-path-convert-befs.patch
struct-path-convert-bfs.patch
struct-path-convert-block.patch
struct-path-convert-block_drivers.patch
struct-path-convert-char-drivers.patch
struct-path-convert-coda.patch
struct-path-convert-cosa.patch
struct-path-convert-cramfs.patch
struct-path-convert-cris.patch
struct-path-convert-drm.patch
struct-path-convert-efs.patch
struct-path-convert-freevxfs.patch
struct-path-convert-frv.patch
struct-path-convert-fuse.patch
struct-path-convert-gfs2.patch
struct-path-convert-hfs.patch
struct-path-convert-hfsplus.patch
struct-path-convert-hostfs.patch
struct-path-convert-hpfs.patch
struct-path-convert-hppfs.patch
struct-path-convert-hugetlbfs.patch
struct-path-convert-i2c-drivers.patch
struct-path-convert-ia64.patch
struct-path-convert-ieee1394.patch
struct-path-convert-infiniband.patch
struct-path-convert-ipc.patch
struct-path-convert-ipmi.patch
struct-path-convert-isapnp.patch
struct-path-convert-isdn.patch
struct-path-convert-ixj.patch
struct-path-convert-jffs.patch
struct-path-convert-jffs2.patch
struct-path-convert-jfs.patch
struct-path-convert-kernel.patch
struct-path-convert-lockd.patch
struct-path-convert-md.patch
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

