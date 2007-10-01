From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:14:40 -0700
Message-ID: <200710010714.l917Ee4u004548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbXJAHVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:21:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in include/linux/nfs_fs.h
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in include/linux/nfs_fs.h
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	include/linux/nfs_fs.h

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nfs_fs.h |    2 --
 1 files changed, 2 deletions(-)

diff -puN include/linux/nfs_fs.h~clean-up-duplicate-includes-in-include-linux-nfs_fsh include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~clean-up-duplicate-includes-in-include-linux-nfs_fsh
+++ a/include/linux/nfs_fs.h
@@ -47,10 +47,8 @@
 #include <linux/nfs3.h>
 #include <linux/nfs4.h>
 #include <linux/nfs_xdr.h>
-
 #include <linux/nfs_fs_sb.h>
 
-#include <linux/rwsem.h>
 #include <linux/mempool.h>
 
 /*
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-cifs.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-mtd.patch
git-ubi.patch
git-net.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-nfs.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
uml-remove-unneeded-void-cast.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
fbdev-update-documentation-fb-00-index.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
