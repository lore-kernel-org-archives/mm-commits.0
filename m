From: akpm@linux-foundation.org
Subject: - libata-add-ich8m-pciids-to-ata_piix.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:52:12 -0700
Message-ID: <200707060052.l660qCXZ028352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41557 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761023AbXGFAzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chunkeey@web.de, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: add ICH8M PCIIDs to ATA_PIIX
has been removed from the -mm tree.  Its filename was
     libata-add-ich8m-pciids-to-ata_piix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: add ICH8M PCIIDs to ATA_PIIX
From: Chr <chunkeey@web.de>

Add a necessary PCIID for Santa Rosa's PATA controller.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/ata/ata_piix.c~libata-add-ich8m-pciids-to-ata_piix drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~libata-add-ich8m-pciids-to-ata_piix
+++ a/drivers/ata/ata_piix.c
@@ -200,6 +200,8 @@ static const struct pci_device_id piix_p
 	/* ICH7/7-R (i945, i975) UDMA 100*/
 	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
 	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	/* ICH8 Mobile PATA Controller */
+	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
 
 	/* NOTE: The following PCI ids must be kept in sync with the
 	 * list in drivers/pci/quirks.c.
_

Patches currently in -mm which might be from chunkeey@web.de are

git-libata-all.patch
