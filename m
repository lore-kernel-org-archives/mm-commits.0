From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:30 -0700
Message-ID: <200707181852.l6IIqUPt023682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933065AbXGRSxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ak@suse.de, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     fix XEN_BLKDEV_FRONTEND Makefile entry
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix XEN_BLKDEV_FRONTEND Makefile entry
From: Adrian Bunk <bunk@stusta.de>

CONFIG_XEN_BLKDEV_FRONTEND shouldn't silently prevent the compilation of
most other block drivers.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/Makefile~fix-x86_64-mm-xen-add-xen-virtual-block-device-driver drivers/block/Makefile
--- a/drivers/block/Makefile~fix-x86_64-mm-xen-add-xen-virtual-block-device-driver
+++ a/drivers/block/Makefile
@@ -27,6 +27,4 @@ obj-$(CONFIG_BLK_DEV_CRYPTOLOOP) += cryp
 obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
-obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	:= xen-blkfront.o
-
-
+obj-$(CONFIG_XEN_BLKDEV_FRONTEND) += xen-blkfront.o
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
mm-variable-length-argument-support.patch
kernel-relayc-make-functions-static.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-dvb.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-xen-event-channels.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
drivers-edac-core-make-functions-static.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
