From: akpm@linux-foundation.org
Subject: [merged] ahci-add-the-device-ids-for-mcp89-and-remove-ids-of-mcp7b-to-from-ahcic.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:23 -0800
Message-ID: <200903061928.n26JSNDI022757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754911AbZCFTaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ahci: add the Device IDs for MCP89 and remove IDs of MCP7B to/from ahci.c
has been removed from the -mm tree.  Its filename was
     ahci-add-the-device-ids-for-mcp89-and-remove-ids-of-mcp7b-to-from-ahcic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ahci: add the Device IDs for MCP89 and remove IDs of MCP7B to/from ahci.c
From: Peer Chen <peerchen@gmail.com>

Add the Device IDs for MCP89 AHCI controller.

Remove the IDs of MCP7B because this chipset had been cancelled.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/ata/ahci.c~ahci-add-the-device-ids-for-mcp89-and-remove-ids-of-mcp7b-to-from-ahcic drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-add-the-device-ids-for-mcp89-and-remove-ids-of-mcp7b-to-from-ahcic
+++ a/drivers/ata/ahci.c
@@ -582,18 +582,18 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc8), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc9), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bca), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bcb), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bcc), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc4), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc5), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc6), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc7), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0d84), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d85), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d86), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d87), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d88), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d89), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8a), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8b), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8c), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8d), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8e), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8f), board_ahci },		/* MCP89 */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci },		/* SiS 966 */
_

Patches currently in -mm which might be from peerchen@gmail.com are

linux-next.patch

