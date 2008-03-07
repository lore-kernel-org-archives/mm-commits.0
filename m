From: akpm@linux-foundation.org
Subject: + ahci-add-the-device-ids-of-nvidia-mcp7b-ahci-controller-to-ahcic.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:15:47 -0800
Message-ID: <200803070815.m278FlL2012573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbYCGIUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:20:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com


The patch titled
     From: "peerchen" <peerchen@gmail.com>
has been added to the -mm tree.  Its filename is
     ahci-add-the-device-ids-of-nvidia-mcp7b-ahci-controller-to-ahcic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: "peerchen" <peerchen@gmail.com>


Add the device IDs of nvidia MCP79 AHCI controller to ahci.c

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/ata/ahci.c~ahci-add-the-device-ids-of-nvidia-mcp7b-ahci-controller-to-ahcic drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-add-the-device-ids-of-nvidia-mcp7b-ahci-controller-to-ahcic
+++ a/drivers/ata/ahci.c
@@ -567,6 +567,18 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc8), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc9), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bca), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcb), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcc), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd0), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd1), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd2), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd3), board_ahci },		/* MCP7B */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
_

Patches currently in -mm which might be from peerchen@gmail.com are

git-alsa.patch
ahci-add-the-device-ids-of-nvidia-mcp7b-ahci-controller-to-ahcic.patch

