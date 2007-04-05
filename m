From: akpm@linux-foundation.org
Subject: - pata_winbond-restore-cable-method.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:16 -0700
Message-ID: <200704050200.l3520GdS004804@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbXDECAX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_winbond: restore cable method
has been removed from the -mm tree.  Its filename was
     pata_winbond-restore-cable-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_winbond: restore cable method
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_winbond.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/pata_winbond.c~pata_winbond-restore-cable-method drivers/ata/pata_winbond.c
--- a/drivers/ata/pata_winbond.c~pata_winbond-restore-cable-method
+++ a/drivers/ata/pata_winbond.c
@@ -152,6 +152,7 @@ static struct ata_port_operations winbon
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
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
