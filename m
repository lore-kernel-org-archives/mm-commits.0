From: akpm@linux-foundation.org
Subject: - pci_ids-update-patch-for-intel-ich9m.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:20 -0700
Message-ID: <200706011747.l51HlJCA015117@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760732AbXFARr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.d.gaston@intel.com, greg@kroah.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pci_ids: update patch for Intel ICH9M
has been removed from the -mm tree.  Its filename was
     pci_ids-update-patch-for-intel-ich9m.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci_ids: update patch for Intel ICH9M
From: Jason Gaston <jason.d.gaston@intel.com>

This patch updates the Intel ICH9M LPC Controller DID's, due to a
specification change.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Cc: <stable@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/pci_ids.h~pci_ids-update-patch-for-intel-ich9m include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pci_ids-update-patch-for-intel-ich9m
+++ a/include/linux/pci_ids.h
@@ -2269,11 +2269,11 @@
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

origin.patch
