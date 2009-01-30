From: akpm@linux-foundation.org
Subject: + irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:00:16 -0800
Message-ID: <200901302000.n0UK0Gu4019552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbZA3UAb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:00:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seth.heasley@intel.com, jbarnes@virtuousgeek.org, khali@linux-fr.org, mingo@elte.hu


The patch titled
     irq: irq and pci_ids patch for Intel Tigerpoint DeviceIDs
has been added to the -mm tree.  Its filename is
     irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

irq-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids.patch

