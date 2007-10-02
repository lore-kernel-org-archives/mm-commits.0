From: akpm@linux-foundation.org
Subject: - ahci-add-mcp79-support-to-ahci-driver-update.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:55:18 -0700
Message-ID: <200710022255.l92MtIei026775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194AbXJBWzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ahci: Add MCP79 support to AHCI driver (update)
has been removed from the -mm tree.  Its filename was
     ahci-add-mcp79-support-to-ahci-driver-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ahci: Add MCP79 support to AHCI driver (update)
From: "Peer Chen" <peerchen@gmail.com>

Code change, remove some Device IDs.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/ata/ahci.c~ahci-add-mcp79-support-to-ahci-driver-update drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-add-mcp79-support-to-ahci-driver-update
+++ a/drivers/ata/ahci.c
@@ -466,10 +466,6 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
_

Patches currently in -mm which might be from peerchen@gmail.com are

git-alsa.patch
git-libata-all.patch
