From: akpm@linux-foundation.org
Subject: - pci-add-pci-identifiers-for-the-rdc-devices.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:27 -0800
Message-ID: <200711091913.lA9JDR6T028033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbXKITSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:18:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian.fainelli@telecomint.eu, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     pci: add PCI identifiers for the RDC devices
has been removed from the -mm tree.  Its filename was
     pci-add-pci-identifiers-for-the-rdc-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci: add PCI identifiers for the RDC devices
From: Florian Fainelli <florian.fainelli@telecomint.eu>

Define the PCI identifiers found in the RDC R-321x System-on-Chip.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/pci_ids.h~pci-add-pci-identifiers-for-the-rdc-devices include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pci-add-pci-identifiers-for-the-rdc-devices
+++ a/include/linux/pci_ids.h
@@ -2105,6 +2105,13 @@
 #define PCI_DEVICE_ID_HERC_WIN		0x5732
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
+#define PCI_VENDOR_ID_RDC		0x17f3
+#define PCI_DEVICE_ID_RDC_R6020		0x6020
+#define PCI_DEVICE_ID_RDC_R6030		0x6030
+#define PCI_DEVICE_ID_RDC_R6040		0x6040
+#define PCI_DEVICE_ID_RDC_R6060		0x6060
+#define PCI_DEVICE_ID_RDC_R6061		0x6061
+
 #define PCI_VENDOR_ID_SITECOM		0x182d
 #define PCI_DEVICE_ID_SITECOM_DC105V2	0x3069
 
_

Patches currently in -mm which might be from florian.fainelli@telecomint.eu are

git-x86.patch
