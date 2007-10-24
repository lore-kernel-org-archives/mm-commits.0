From: akpm@linux-foundation.org
Subject: + forcedeth-new-device-ids.patch added to -mm tree
Date: Wed, 24 Oct 2007 16:09:49 -0700
Message-ID: <200710242309.l9ON9nYq017288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbXJXXJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 19:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: new device ids
has been added to the -mm tree.  Its filename is
     forcedeth-new-device-ids.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: new device ids
From: Ayaz Abdulla <aabdulla@nvidia.com>

Add new device ids for mcp77 devices.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/pci_ids.h~forcedeth-new-device-ids include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~forcedeth-new-device-ids
+++ a/include/linux/pci_ids.h
@@ -1236,6 +1236,10 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
+#define PCI_DEVICE_ID_NVIDIA_NVENET_32              0x0760
+#define PCI_DEVICE_ID_NVIDIA_NVENET_33              0x0761
+#define PCI_DEVICE_ID_NVIDIA_NVENET_34              0x0762
+#define PCI_DEVICE_ID_NVIDIA_NVENET_35              0x0763
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
forcedeth-new-device-ids.patch
a.patch
