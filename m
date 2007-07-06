From: akpm@linux-foundation.org
Subject: - sata_mv-pci-id-for-adaptec-1430sa-sata-controller.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:52:19 -0700
Message-ID: <200707060052.l660qJm6028361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760983AbXGFAyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valdyn@gmail.com, hancockr@shaw.ca, mm-commits@vger.kernel.org


The patch titled
     sata_mv: PCI-ID for Adaptec 1430SA SATA Controller
has been removed from the -mm tree.  Its filename was
     sata_mv-pci-id-for-adaptec-1430sa-sata-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_mv: PCI-ID for Adaptec 1430SA SATA Controller
From: Florian Attenberger <valdyn@gmail.com>

Signed-off-by: Florian Attenberger <valdyn@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/ata/sata_mv.c~sata_mv-pci-id-for-adaptec-1430sa-sata-controller drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~sata_mv-pci-id-for-adaptec-1430sa-sata-controller
+++ a/drivers/ata/sata_mv.c
@@ -582,6 +582,9 @@ static const struct pci_device_id mv_pci
 
 	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
 
+	/* Adaptec 1430SA */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
+
 	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
 
 	/* add Marvell 7042 support */
_

Patches currently in -mm which might be from valdyn@gmail.com are

origin.patch
