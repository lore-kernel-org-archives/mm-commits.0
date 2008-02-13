From: akpm@linux-foundation.org
Subject: - fix-ide-legacy-gaylec-compilation.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:34 -0800
Message-ID: <200802132015.m1DKFYUX011379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762496AbYBMUPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fix ide/legacy/gayle.c compilation
has been removed from the -mm tree.  Its filename was
     fix-ide-legacy-gaylec-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix ide/legacy/gayle.c compilation
From: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/legacy/gayle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ide/legacy/gayle.c~fix-ide-legacy-gaylec-compilation drivers/ide/legacy/gayle.c
--- a/drivers/ide/legacy/gayle.c~fix-ide-legacy-gaylec-compilation
+++ a/drivers/ide/legacy/gayle.c
@@ -94,7 +94,7 @@ static int gayle_ack_intr_a1200(ide_hwif
 
 static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
 				     unsigned long ctl, unsigned long irq_port,
-				     ide_ack_intr_t *ack_intr);
+				     ide_ack_intr_t *ack_intr)
 {
 	int i;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-net.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
sparc-fix-build.patch
reiser4.patch
