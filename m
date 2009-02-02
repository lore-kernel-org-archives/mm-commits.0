From: akpm@linux-foundation.org
Subject: [merged] irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:36:55 -0800
Message-ID: <200902021936.n12Jat14013469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbZBBThY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seth.heasley@intel.com, jbarnes@virtuousgeek.org, khali@linux-fr.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     irq: irq and pci_ids patch for Intel Tigerpoint DeviceIDs
has been removed from the -mm tree.  Its filename was
     irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irq: irq and pci_ids patch for Intel Tigerpoint DeviceIDs
From: Seth Heasley <seth.heasley@intel.com>

This patch adds the Intel Tigerpoint LPC Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/irq.c      |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/x86/pci/irq.c~irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids
+++ a/arch/x86/pci/irq.c
@@ -572,6 +572,7 @@ static __init int intel_router_probe(str
 	case PCI_DEVICE_ID_INTEL_ICH7_1:
 	case PCI_DEVICE_ID_INTEL_ICH7_30:
 	case PCI_DEVICE_ID_INTEL_ICH7_31:
+	case PCI_DEVICE_ID_INTEL_TGP_LPC:
 	case PCI_DEVICE_ID_INTEL_ESB2_0:
 	case PCI_DEVICE_ID_INTEL_ICH8_0:
 	case PCI_DEVICE_ID_INTEL_ICH8_1:
diff -puN include/linux/pci_ids.h~irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids
+++ a/include/linux/pci_ids.h
@@ -2429,6 +2429,7 @@
 #define PCI_DEVICE_ID_INTEL_ICH7_0	0x27b8
 #define PCI_DEVICE_ID_INTEL_ICH7_1	0x27b9
 #define PCI_DEVICE_ID_INTEL_ICH7_30	0x27b0
+#define PCI_DEVICE_ID_INTEL_TGP_LPC	0x27bc
 #define PCI_DEVICE_ID_INTEL_ICH7_31	0x27bd
 #define PCI_DEVICE_ID_INTEL_ICH7_17	0x27da
 #define PCI_DEVICE_ID_INTEL_ICH7_19	0x27dd
_

Patches currently in -mm which might be from seth.heasley@intel.com are

linux-next.patch

