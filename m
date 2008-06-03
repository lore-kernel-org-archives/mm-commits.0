From: akpm@linux-foundation.org
Subject: - ahci-fix-the-device-ids-of-nvidia-mcp7b-ahci-controller-in-ahcic.patch removed from -mm tree
Date: Tue, 03 Jun 2008 12:02:39 -0700
Message-ID: <200806031902.m53J2dmS014815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323AbYFCTD0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:03:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ahci: fix the Device IDs of nvidia MCP7B AHCI controller in ahci.c
has been removed from the -mm tree.  Its filename was
     ahci-fix-the-device-ids-of-nvidia-mcp7b-ahci-controller-in-ahcic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ahci: fix the Device IDs of nvidia MCP7B AHCI controller in ahci.c
From: Peer Chen <peerchen@gmail.com>

Fix the partial Device IDs of nvidia MCP7B AHCI controller in ahci.c. 
Incorrect IDs were being used.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/ata/ahci.c~ahci-fix-the-device-ids-of-nvidia-mcp7b-ahci-controller-in-ahcic drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-fix-the-device-ids-of-nvidia-mcp7b-ahci-controller-in-ahcic
+++ a/drivers/ata/ahci.c
@@ -502,10 +502,10 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
 	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
 	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd0), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd1), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd2), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd3), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc4), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc5), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc6), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc7), board_ahci },		/* MCP7B */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
_

Patches currently in -mm which might be from peerchen@gmail.com are

origin.patch

