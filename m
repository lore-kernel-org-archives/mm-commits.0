From: akpm@linux-foundation.org
Subject: - pata_ixp4xx_cf-restore-cable-type-method.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:45 -0800
Message-ID: <200703152157.l2FLvj6x027665@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42409 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbXCOV55 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_ixp4xx_cf: restore cable type method
has been removed from the -mm tree.  Its filename was
     pata_ixp4xx_cf-restore-cable-type-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_ixp4xx_cf: restore cable type method
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ixp4xx_cf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/pata_ixp4xx_cf.c~pata_ixp4xx_cf-restore-cable-type-method drivers/ata/pata_ixp4xx_cf.c
--- a/drivers/ata/pata_ixp4xx_cf.c~pata_ixp4xx_cf-restore-cable-type-method
+++ a/drivers/ata/pata_ixp4xx_cf.c
@@ -129,6 +129,7 @@ static struct ata_port_operations ixp4xx
 	.qc_issue	= ata_qc_issue_prot,
 	.eng_timeout	= ata_eng_timeout,
 	.data_xfer	= ixp4xx_mmio_data_xfer,
+	.cable_detect	= ata_cable_40wire,
 
 	.irq_handler	= ata_interrupt,
 	.irq_clear	= ixp4xx_irq_clear,
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_ali-remove-all-the-crap-again-and-switch-to.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_netcell-re-remove-all-the-crud.patch
pata_qdi-restore-cable-detect.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_winbond-restore-cable-method.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_pdc2027x-restore-various-updates-done-on-the-driver.patch
pata_acpi-restore-driver.patch
resend-iphase-64bit-cleanup.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
