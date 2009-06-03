From: akpm@linux-foundation.org
Subject: [folded] new-pci-device-id.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:24:24 -0700
Message-ID: <200906032024.n53KOOfl018930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbZFCUYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     new pci device id
has been removed from the -mm tree.  Its filename was
     new-pci-device-id.patch

This patch was dropped because it was folded into forcedeth-addition-of-new-device-id.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: new pci device id
From: Ayaz Abdulla <aabdulla@nvidia.com>

Add a new NVIDIA ethernet device id for the MCP89 chipset.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/pci_ids.h~new-pci-device-id include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~new-pci-device-id
+++ a/include/linux/pci_ids.h
@@ -1289,6 +1289,7 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_37              0x0AB1
 #define PCI_DEVICE_ID_NVIDIA_NVENET_38              0x0AB2
 #define PCI_DEVICE_ID_NVIDIA_NVENET_39              0x0AB3
+#define PCI_DEVICE_ID_NVIDIA_NVENET_40              0x0D7D
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

linux-next.patch
forcedeth-addition-of-new-device-id.patch
new-pci-device-id.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch

