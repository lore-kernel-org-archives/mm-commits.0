From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-drivers-spi.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:39 -0700
Message-ID: <200710162039.l9GKddF2015563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936120AbXJPVHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in drivers/spi/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-drivers-spi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in drivers/spi/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	drivers/spi/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c  |    1 -
 drivers/spi/spi_bfin5xx.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~clean-up-duplicate-includes-in-drivers-spi drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~clean-up-duplicate-includes-in-drivers-spi
+++ a/drivers/spi/pxa2xx_spi.c
@@ -26,7 +26,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
-#include <linux/errno.h>
 #include <linux/delay.h>
 
 #include <asm/io.h>
diff -puN drivers/spi/spi_bfin5xx.c~clean-up-duplicate-includes-in-drivers-spi drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~clean-up-duplicate-includes-in-drivers-spi
+++ a/drivers/spi/spi_bfin5xx.c
@@ -39,7 +39,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
-#include <linux/errno.h>
 #include <linux/delay.h>
 
 #include <asm/io.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
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
