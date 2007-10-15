From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-fs-ntfs.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:32 -0700
Message-ID: <200710150917.l9F9HWkF027284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222AbXJOJSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in fs/ntfs/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-fs-ntfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in fs/ntfs/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	fs/ntfs/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c  |    1 -
 fs/ntfs/inode.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN fs/ntfs/file.c~clean-up-duplicate-includes-in-fs-ntfs fs/ntfs/file.c
--- a/fs/ntfs/file.c~clean-up-duplicate-includes-in-fs-ntfs
+++ a/fs/ntfs/file.c
@@ -26,7 +26,6 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
-#include <linux/sched.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
diff -puN fs/ntfs/inode.c~clean-up-duplicate-includes-in-fs-ntfs fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~clean-up-duplicate-includes-in-fs-ntfs
+++ a/fs/ntfs/inode.c
@@ -34,7 +34,6 @@
 #include "dir.h"
 #include "debug.h"
 #include "inode.h"
-#include "attrib.h"
 #include "lcnalloc.h"
 #include "malloc.h"
 #include "mft.h"
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-kbuild.patch
git-nfs.patch
git-scsi-misc.patch
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
