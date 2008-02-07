From: akpm@linux-foundation.org
Subject: - scsi-advansysc-make-3-functions-static.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:31:11 -0800
Message-ID: <200802070030.m170UqXC007428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760930AbYBGAnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     scsi/advansys.c: make 3 functions static
has been removed from the -mm tree.  Its filename was
     scsi-advansysc-make-3-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi/advansys.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/advansys.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/advansys.c~scsi-advansysc-make-3-functions-static drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~scsi-advansysc-make-3-functions-static
+++ a/drivers/scsi/advansys.c
@@ -12261,7 +12261,7 @@ static ushort __devinit AdvReadEEPWord(A
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -12328,7 +12328,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -12395,7 +12395,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_b
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
