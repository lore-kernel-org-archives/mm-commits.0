From: akpm@linux-foundation.org
Subject: + ahci-add-the-device-ids-of-mcp79-ahci-controller-to-ahcic.patch added to -mm tree
Date: Mon, 03 Dec 2007 21:50:05 -0800
Message-ID: <200712040550.lB45o5It003288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbXLDFuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 00:50:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com


The patch titled
     ahci: add the device IDs of MCP79 AHCI controller to ahci.c
has been added to the -mm tree.  Its filename is
     ahci-add-the-device-ids-of-mcp79-ahci-controller-to-ahcic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ahci: add the device IDs of MCP79 AHCI controller to ahci.c
From: "peerchen" <peerchen@gmail.com>

Add the device IDs of legacy mode of MCP79 AHCI controller to ahci.c

Signed-off-by: Peer Chen <peerchen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/ata/ahci.c~ahci-add-the-device-ids-of-mcp79-ahci-controller-to-ahcic drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-add-the-device-ids-of-mcp79-ahci-controller-to-ahcic
+++ a/drivers/ata/ahci.c
@@ -546,6 +546,10 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
_

Patches currently in -mm which might be from peerchen@gmail.com are

ahci-add-the-device-ids-of-mcp79-ahci-controller-to-ahcic.patch
