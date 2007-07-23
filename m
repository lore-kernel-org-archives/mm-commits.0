From: akpm@linux-foundation.org
Subject: + forcedeth-new-device-ids-in-pci_idsh.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:49:18 -0700
Message-ID: <200707232349.l6NNnIA1018404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761291AbXGWXtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: new device ids in pci_ids.h
has been added to the -mm tree.  Its filename is
     forcedeth-new-device-ids-in-pci_idsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: new device ids in pci_ids.h
From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch contains new device ids for MCP73 chipset.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN include/linux/pci_ids.h~forcedeth-new-device-ids-in-pci_idsh include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~forcedeth-new-device-ids-in-pci_idsh
+++ a/include/linux/pci_ids.h
@@ -1225,6 +1225,10 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_25              0x054D
 #define PCI_DEVICE_ID_NVIDIA_NVENET_26              0x054E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_27              0x054F
+#define PCI_DEVICE_ID_NVIDIA_NVENET_28              0x07DC
+#define PCI_DEVICE_ID_NVIDIA_NVENET_29              0x07DD
+#define PCI_DEVICE_ID_NVIDIA_NVENET_30              0x07DE
+#define PCI_DEVICE_ID_NVIDIA_NVENET_31              0x07DF
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

forcedeth-new-device-ids-in-pci_idsh.patch
forcedeth-mcp73-device-addition.patch
