From: akpm@linux-foundation.org
Subject: [merged] pci-add-amd8111-pci-bridge-pci-device-id.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:51 -0700
Message-ID: <200904061936.n36JaptN012668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757907AbZDFTjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     pci: Add AMD8111 PCI Bridge PCI Device ID
has been removed from the -mm tree.  Its filename was
     pci-add-amd8111-pci-bridge-pci-device-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: Add AMD8111 PCI Bridge PCI Device ID
From: Harry Ciao <qingtao.cao@windriver.com>

Add the PCI Device ID of the PCI Bridge Controller on AMD8111 chip.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/pci_ids.h~pci-add-amd8111-pci-bridge-pci-device-id include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pci-add-amd8111-pci-bridge-pci-device-id
+++ a/include/linux/pci_ids.h
@@ -526,6 +526,7 @@
 #define PCI_DEVICE_ID_AMD_OPUS_7443	0x7443
 #define PCI_DEVICE_ID_AMD_VIPER_7443	0x7443
 #define PCI_DEVICE_ID_AMD_OPUS_7445	0x7445
+#define PCI_DEVICE_ID_AMD_8111_PCI	0x7460
 #define PCI_DEVICE_ID_AMD_8111_LPC	0x7468
 #define PCI_DEVICE_ID_AMD_8111_IDE	0x7469
 #define PCI_DEVICE_ID_AMD_8111_SMBUS2	0x746a
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

origin.patch

