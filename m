From: akpm@linux-foundation.org
Subject: - ahci-add-mcp73-mcp77-support-to-ahci-driver.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:01 -0700
Message-ID: <200706121858.l5CIw1xM018510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42499 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbXFLTBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ahci: Add MCP73/MCP77 support to AHCI driver
has been removed from the -mm tree.  Its filename was
     ahci-add-mcp73-mcp77-support-to-ahci-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ahci: Add MCP73/MCP77 support to AHCI driver
From: "Peer Chen" <peerchen@gmail.com>

Add the MCP73/MCP77 support to ahci driver.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/ata/ahci.c~ahci-add-mcp73-mcp77-support-to-ahci-driver drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-add-mcp73-mcp77-support-to-ahci-driver
+++ a/drivers/ata/ahci.c
@@ -442,6 +442,30 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci },		/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad3), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad4), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad5), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad6), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad7), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad8), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
_

Patches currently in -mm which might be from peerchen@gmail.com are

origin.patch
git-alsa.patch
