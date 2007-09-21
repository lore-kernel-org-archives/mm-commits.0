From: akpm@linux-foundation.org
Subject: + ahci-add-mcp79-support-to-ahci-driver.patch added to -mm tree
Date: Fri, 21 Sep 2007 03:30:25 -0700
Message-ID: <200709211030.l8LAUPew031048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbXIUKa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 06:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com


The patch titled
     ahci: add MCP79 support to AHCI driver
has been added to the -mm tree.  Its filename is
     ahci-add-mcp79-support-to-ahci-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ahci: add MCP79 support to AHCI driver
From: "Peer Chen" <peerchen@gmail.com>

Add the MCP79 support to ahci driver.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/ata/ahci.c~ahci-add-mcp79-support-to-ahci-driver drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-add-mcp79-support-to-ahci-driver
+++ a/drivers/ata/ahci.c
@@ -472,6 +472,18 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abb), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abc), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
_

Patches currently in -mm which might be from peerchen@gmail.com are

ahci-enable-ghcae-bit-before-set-ghchr.patch
ahci-enable-ghcae-bit-before-set-ghchr-fix.patch
ahci-add-mcp79-support-to-ahci-driver.patch
