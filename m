From: akpm@linux-foundation.org
Subject: - pata_platform-set-a-cable-type-which-to-set.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:48:12 -0800
Message-ID: <200703072348.l27NmCHx013391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXCGXs1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:48:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_platform: set a cable type (which to set ?)
has been removed from the -mm tree.  Its filename was
     pata_platform-set-a-cable-type-which-to-set.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_platform: set a cable type (which to set ?)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_platform.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/pata_platform.c~pata_platform-set-a-cable-type-which-to-set drivers/ata/pata_platform.c
--- a/drivers/ata/pata_platform.c~pata_platform-set-a-cable-type-which-to-set
+++ a/drivers/ata/pata_platform.c
@@ -80,6 +80,7 @@ static struct ata_port_operations pata_p
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_unknown,
 
 	.qc_prep		= ata_qc_prep,
 	.qc_issue		= ata_qc_issue_prot,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_sl82c105-missing-methods-cable.patch
pata_isapnp-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
pata_winbond-set-cable-type.patch
ata_piix-remove-ugly-layering-violation.patch
pata_mpc52xx-cable-detect.patch
pata_mpiix-cable-detect-method.patch
pata_ns87410-cable-detect-method.patch
pata_oldpiix-cable-detect.patch
pata_opti-cable-detect.patch
pata_pcmcia-cable-detect.patch
pata_triflex-cable-detect.patch
pata_cmd640-multiple-updates.patch
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
