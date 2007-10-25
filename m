From: akpm@linux-foundation.org
Subject: + pci-add-pci-identifiers-for-the-rdc-devices.patch added to -mm tree
Date: Thu, 25 Oct 2007 14:23:50 -0700
Message-ID: <200710252123.l9PLNo9d024712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbXJYVYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 17:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian.fainelli@telecomint.eu, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     pci: add PCI identifiers for the RDC devices
has been added to the -mm tree.  Its filename is
     pci-add-pci-identifiers-for-the-rdc-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

add-generic-gpio-support-to-x86.patch
pci-add-pci-identifiers-for-the-rdc-devices.patch
add-support-for-the-rdc-r-321x-soc.patch
add-the-rdc-machine-specific-reboot-fixup.patch
