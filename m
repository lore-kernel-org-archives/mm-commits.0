From: akpm@linux-foundation.org
Subject: - scsi-lpfc-lpfc_initc-remove-unused-variable.patch removed from -mm tree
Date: Tue, 22 May 2007 13:56:55 -0700
Message-ID: <200705222056.l4MKusGY009595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873AbXEVU6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:58:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, James.Smart@Emulex.Com, mm-commits@vger.kernel.org


The patch titled
     scsi/lpfc/lpfc_init.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     scsi-lpfc-lpfc_initc-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi/lpfc/lpfc_init.c: remove unused variable
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-lpfc_initc-remove-unused-variable drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-lpfc_initc-remove-unused-variable
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1512,7 +1512,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	struct lpfc_sli  *psli;
 	struct lpfc_iocbq *iocbq_entry = NULL, *iocbq_next = NULL;
 	unsigned long bar0map_len, bar2map_len;
-	int error = -ENODEV, retval;
+	int error = -ENODEV;
 	int i;
 	uint16_t iotag;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-rc-fixes.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
