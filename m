From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-drivers-scsi.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:07 -0700
Message-ID: <200708201913.l7KJD74n018407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758035AbXHTTVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, james.smart@Emulex.Com, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in drivers/scsi/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-drivers-scsi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in drivers/scsi/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	drivers/scsi/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR_D700.c          |    1 -
 drivers/scsi/lpfc/lpfc_debugfs.c |    1 -
 drivers/scsi/lpfc/lpfc_init.c    |    1 -
 3 files changed, 3 deletions(-)

diff -puN drivers/scsi/NCR_D700.c~clean-up-duplicate-includes-in-drivers-scsi drivers/scsi/NCR_D700.c
--- a/drivers/scsi/NCR_D700.c~clean-up-duplicate-includes-in-drivers-scsi
+++ a/drivers/scsi/NCR_D700.c
@@ -97,7 +97,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mca.h>
-#include <linux/interrupt.h>
 #include <asm/io.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
diff -puN drivers/scsi/lpfc/lpfc_debugfs.c~clean-up-duplicate-includes-in-drivers-scsi drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c~clean-up-duplicate-includes-in-drivers-scsi
+++ a/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -43,7 +43,6 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
-#include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_LPFC_DEBUG_FS
diff -puN drivers/scsi/lpfc/lpfc_init.c~clean-up-duplicate-includes-in-drivers-scsi drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~clean-up-duplicate-includes-in-drivers-scsi
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -43,7 +43,6 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
-#include "lpfc_vport.h"
 
 static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-watchdog.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
