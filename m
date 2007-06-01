From: akpm@linux-foundation.org
Subject: - misc-tifm_7xx1-replace-deprecated-irq-flag.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:38 -0700
Message-ID: <200706011747.l51HlbNK015141@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761289AbXFARrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     misc/tifm_7xx1: replace deprecated irq flag
has been removed from the -mm tree.  Its filename was
     misc-tifm_7xx1-replace-deprecated-irq-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: misc/tifm_7xx1: replace deprecated irq flag
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/tifm_7xx1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/tifm_7xx1.c~misc-tifm_7xx1-replace-deprecated-irq-flag drivers/misc/tifm_7xx1.c
--- a/drivers/misc/tifm_7xx1.c~misc-tifm_7xx1-replace-deprecated-irq-flag
+++ a/drivers/misc/tifm_7xx1.c
@@ -343,7 +343,7 @@ static int tifm_7xx1_probe(struct pci_de
 	if (!fm->addr)
 		goto err_out_free;
 
-	rc = request_irq(dev->irq, tifm_7xx1_isr, SA_SHIRQ, DRIVER_NAME, fm);
+	rc = request_irq(dev->irq, tifm_7xx1_isr, IRQF_SHARED, DRIVER_NAME, fm);
 	if (rc)
 		goto err_out_unmap;
 
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
git-ubi.patch
git-netdev-all.patch
8139too-force-media-setting-fix.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-net.patch
git-ioat.patch
remove-pci_dac_dma_-apis.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
s390-spinlock-initializer-cleanup.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups-update.patch
git-gccbug.patch
