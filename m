From: akpm@linux-foundation.org
Subject: - forcedeth-mcp73-device-addition.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:25:26 -0700
Message-ID: <200707242325.l6ONPQb6006364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227AbXGXXgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: mcp73 device addition
has been removed from the -mm tree.  Its filename was
     forcedeth-mcp73-device-addition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: mcp73 device addition
From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch contains new device settings for MCP73 chipset.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

diff -puN drivers/net/forcedeth.c~forcedeth-mcp73-device-addition drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-mcp73-device-addition
+++ a/drivers/net/forcedeth.c
@@ -5546,6 +5546,22 @@ static struct pci_device_id pci_tbl[] = 
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_27),
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
 	},
+	{	/* MCP73 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_28),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP73 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_29),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP73 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_30),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP73 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_31),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
 	{0,},
 };
 
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

git-netdev-all.patch
