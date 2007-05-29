From: akpm@linux-foundation.org
Subject: + pci_ids-update-patch-for-intel-ich9m.patch added to -mm tree
Date: Tue, 29 May 2007 15:26:00 -0700
Message-ID: <200705292226.l4TMQ0T8013141@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbXE2W0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.d.gaston@intel.com, akpm@linux-foundation.org, stable@kernel.org


The patch titled
     pci_ids: update patch for Intel ICH9M
has been added to the -mm tree.  Its filename is
     pci_ids-update-patch-for-intel-ich9m.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci_ids: update patch for Intel ICH9M
From: Jason Gaston <jason.d.gaston@intel.com>

This patch updates the Intel ICH9M LPC Controller DID's, due to a
specification change.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Cc: <stable@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/pci_ids.h~pci_ids-update-patch-for-intel-ich9m include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pci_ids-update-patch-for-intel-ich9m
+++ a/include/linux/pci_ids.h
@@ -2273,11 +2273,11 @@
 #define PCI_DEVICE_ID_INTEL_ICH8_5	0x283e
 #define PCI_DEVICE_ID_INTEL_ICH8_6	0x2850
 #define PCI_DEVICE_ID_INTEL_ICH9_0	0x2910
-#define PCI_DEVICE_ID_INTEL_ICH9_1	0x2911
+#define PCI_DEVICE_ID_INTEL_ICH9_1	0x2917
 #define PCI_DEVICE_ID_INTEL_ICH9_2	0x2912
 #define PCI_DEVICE_ID_INTEL_ICH9_3	0x2913
 #define PCI_DEVICE_ID_INTEL_ICH9_4	0x2914
-#define PCI_DEVICE_ID_INTEL_ICH9_5	0x2915
+#define PCI_DEVICE_ID_INTEL_ICH9_5	0x2919
 #define PCI_DEVICE_ID_INTEL_ICH9_6	0x2930
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
 #define PCI_DEVICE_ID_INTEL_82830_HB	0x3575
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

pci_ids-update-patch-for-intel-ich9m.patch
