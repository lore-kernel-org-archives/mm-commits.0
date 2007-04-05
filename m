From: akpm@linux-foundation.org
Subject: - pata_qdi-restore-cable-detect.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:10 -0700
Message-ID: <200704050200.l3520AeZ004795@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbXDECA0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, number6@the-village.bc.nu, mm-commits@vger.kernel.org


The patch titled
     pata_qdI: restore cable detect
has been removed from the -mm tree.  Its filename was
     pata_qdi-restore-cable-detect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_qdI: restore cable detect
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <number6@the-village.bc.nu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_qdi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/ata/pata_qdi.c~pata_qdi-restore-cable-detect drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~pata_qdi-restore-cable-detect
+++ a/drivers/ata/pata_qdi.c
@@ -183,6 +183,7 @@ static struct ata_port_operations qdi650
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= qdi_qc_issue_prot,
@@ -211,6 +212,7 @@ static struct ata_port_operations qdi658
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= qdi_qc_issue_prot,
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver.patch
pata_acpi-restore-driver-fix.patch
libata-misc-minor-merge-fixups.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
