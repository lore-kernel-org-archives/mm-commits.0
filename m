From: akpm@linux-foundation.org
Subject: + ahci-add-mcp79-support-to-ahci-driver-update.patch added to -mm tree
Date: Sun, 23 Sep 2007 19:34:34 -0700
Message-ID: <200709240234.l8O2YY2Q005604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbXIXCfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 23 Sep 2007 22:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com


The patch titled
     ahci: Add MCP79 support to AHCI driver (update)
has been added to the -mm tree.  Its filename is
     ahci-add-mcp79-support-to-ahci-driver-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -464,10 +464,6 @@ static const struct pci_device_id ahci_p
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
ahci-add-mcp79-support-to-ahci-driver.patch
ahci-add-mcp79-support-to-ahci-driver-update.patch
