From: akpm@linux-foundation.org
Subject: - pata_ixp4xx_cf-set-cable-type.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:40:01 -0800
Message-ID: <200703072340.l27Ne1wS013108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38521 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945907AbXCGXkN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_ixp4xx_cf - set cable type
has been removed from the -mm tree.  Its filename was
     pata_ixp4xx_cf-set-cable-type.patch

This patch was dropped because I can't test it and I don't know if it broke

------------------------------------------------------
Subject: pata_ixp4xx_cf - set cable type
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ixp4xx_cf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/pata_ixp4xx_cf.c~pata_ixp4xx_cf-set-cable-type drivers/ata/pata_ixp4xx_cf.c
--- a/drivers/ata/pata_ixp4xx_cf.c~pata_ixp4xx_cf-set-cable-type
+++ a/drivers/ata/pata_ixp4xx_cf.c
@@ -129,6 +129,7 @@ static struct ata_port_operations ixp4xx
 	.qc_issue	= ata_qc_issue_prot,
 	.eng_timeout	= ata_eng_timeout,
 	.data_xfer	= ixp4xx_mmio_data_xfer,
+	.cable_detect	= ata_cable_40wire,
 
 	.irq_handler	= ata_interrupt,
 	.irq_clear	= ixp4xx_irq_clear,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_qdi-set-cable-type.patch
pata_sl82c105-missing-methods-cable.patch
pata_isapnp-set-cable-type.patch
pata_ixp4xx_cf-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
pata_rz1000-remove-lots-of-crap-by-using-cable-method.patch
pata_winbond-set-cable-type.patch
pata_cmd64x-various-fixes.patch
pata_hpt3x3-clean-up-by-using-cable-method.patch
ata_piix-remove-ugly-layering-violation.patch
pata_artop-cable-detect-methods.patch
pata_cs5535-cable-detect.patch
pata_hpt3x2n-cable-detect-handling-needs-work.patch
pata_it821x-clean-up-by-using-cable-methods.patch
pata_mpc52xx-cable-detect.patch
pata_mpiix-cable-detect-method.patch
pata_ns87410-cable-detect-method.patch
pata_oldpiix-cable-detect.patch
pata_opti-cable-detect.patch
pata_pcmcia-cable-detect.patch
pata_pdc202xx_old-cable-detect-clean-up.patch
pata_sil680-cable-detect.patch
pata_triflex-cable-detect.patch
sata_via-cable-detection.patch
pata_cmd640-multiple-updates.patch
pata_efar-switch-to-cable_detect-method.patch
pata_it8213-cable-detect.patch
pata_marvell-cable-and-reset-fixes.patch
pata_serverworks-cable-detect-and-comment-fix.patch
pata_sis-clean-up-using-cable_detect-methods.patch
pata_via-use-cable_detect-method.patch
pata_hpt366-cable-detect-methods.patch
pata_atiixp-switch-to-cable_detect-method-with-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
dilnetpc-fix-warning.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
z85230-fix-fifo-handling.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
