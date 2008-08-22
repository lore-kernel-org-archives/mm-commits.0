From: akpm@linux-foundation.org
Subject: - ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids.patch removed from -mm tree
Date: Fri, 22 Aug 2008 15:56:01 -0700
Message-ID: <200808222256.m7MMu1lq020876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757617AbYHVW5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 18:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seth.heasley@intel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata_piix: IDE mode SATA patch for Intel Ibex Peak DeviceIDs
has been removed from the -mm tree.  Its filename was
     ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata_piix: IDE mode SATA patch for Intel Ibex Peak DeviceIDs
From: Seth Heasley <seth.heasley@intel.com>

Add the Intel Ibex Peak (PCH) IDE mode SATA Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/ata/ata_piix.c~ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids
+++ a/drivers/ata/ata_piix.c
@@ -275,6 +275,14 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (ICH10) */
 	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 
 	{ }	/* terminate list */
 };
_

Patches currently in -mm which might be from seth.heasley@intel.com are

origin.patch
linux-next.patch

