From: akpm@linux-foundation.org
Subject: + alsa-add-the-mcp73-77-support-to-hda_intel-driver.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:26:44 -0700
Message-ID: <200706080526.l585QiB6019913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763386AbXFHF1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:27:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com


The patch titled
     alsa: add the MCP73/77 support to hda_intel driver
has been added to the -mm tree.  Its filename is
     alsa-add-the-mcp73-77-support-to-hda_intel-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alsa: add the MCP73/77 support to hda_intel driver
From: "Peer Chen" <peerchen@gmail.com>

Add the MCP73/MCP77 support to hda driver.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN sound/pci/hda/hda_intel.c~alsa-add-the-mcp73-77-support-to-hda_intel-driver sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~alsa-add-the-mcp73-77-support-to-hda_intel-driver
+++ a/sound/pci/hda/hda_intel.c
@@ -1788,6 +1788,12 @@ static struct pci_device_id azx_ids[] = 
 	{ 0x10de, 0x044b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP65 */
 	{ 0x10de, 0x055c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP67 */
 	{ 0x10de, 0x055d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP67 */
+	{ 0x10de, 0x07fc, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP73 */
+	{ 0x10de, 0x07fd, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP73 */
+	{ 0x10de, 0x0774, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
+	{ 0x10de, 0x0775, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
+	{ 0x10de, 0x0776, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
+	{ 0x10de, 0x0777, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
_

Patches currently in -mm which might be from peerchen@gmail.com are

alsa-add-the-mcp73-77-support-to-hda_intel-driver.patch
ahci-add-mcp73-mcp77-support-to-ahci-driver.patch
pata-add-the-mcp73-77-support-to-pata-driver.patch
