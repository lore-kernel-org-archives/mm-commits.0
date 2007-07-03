From: akpm@linux-foundation.org
Subject: + sata_mv-pci-id-for-adaptec-1430sa-sata-controller.patch added to -mm tree
Date: Tue, 03 Jul 2007 16:06:48 -0700
Message-ID: <200707032306.l63N6mLV021764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294AbXGCXHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 19:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: valdyn@gmail.com, hancockr@shaw.ca


The patch titled
     sata_mv: PCI-ID for Adaptec 1430SA SATA Controller
has been added to the -mm tree.  Its filename is
     sata_mv-pci-id-for-adaptec-1430sa-sata-controller.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sata_mv-pci-id-for-adaptec-1430sa-sata-controller.patch
