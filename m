From: akpm@linux-foundation.org
Subject: - alsa-add-the-mcp73-77-support-to-hda_intel-driver.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:07 -0700
Message-ID: <200706081735.l58HZ7Ju006340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030537AbXFHRfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     alsa: add the MCP73/77 support to hda_intel driver
has been removed from the -mm tree.  Its filename was
     alsa-add-the-mcp73-77-support-to-hda_intel-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-alsa.patch
ahci-add-mcp73-mcp77-support-to-ahci-driver.patch
pata-add-the-mcp73-77-support-to-pata-driver.patch
