From: akpm@linux-foundation.org
Subject: + fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch added to -mm tree
Date: Mon, 04 Jun 2007 14:17:16 -0700
Message-ID: <200706042117.l54LHGhK019373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbXFDVRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 17:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ak@suse.de, jeremy@goop.org


The patch titled
     fix XEN_BLKDEV_FRONTEND Makefile entry
has been added to the -mm tree.  Its filename is
     fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix XEN_BLKDEV_FRONTEND Makefile entry
From: Adrian Bunk <bunk@stusta.de>

CONFIG_XEN_BLKDEV_FRONTEND shouldn't silently prevent the compilation of
most other block drivers.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/Makefile~fix-x86_64-mm-xen-add-xen-virtual-block-device-driver drivers/block/Makefile
--- a/drivers/block/Makefile~fix-x86_64-mm-xen-add-xen-virtual-block-device-driver
+++ a/drivers/block/Makefile
@@ -28,6 +28,6 @@ obj-$(CONFIG_BLK_DEV_CRYPTOLOOP) += cryp
 obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
-obj-$(CONFIG_XEN_BLKDEV_FRONTEND) := xen-blkfront.o
+obj-$(CONFIG_XEN_BLKDEV_FRONTEND) += xen-blkfront.o
 obj-$(CONFIG_XILINX_SYSACE)	+= xsysace.o
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
