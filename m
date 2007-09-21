From: akpm@linux-foundation.org
Subject: - alsa-add-the-mcp79-support-to-hda_intel-driver.patch removed from -mm tree
Date: Fri, 21 Sep 2007 14:08:09 -0700
Message-ID: <200709212108.l8LL89LF023547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762630AbXIUVJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 17:09:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: add the MCP79 support to hda_intel driver
has been removed from the -mm tree.  Its filename was
     alsa-add-the-mcp79-support-to-hda_intel-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alsa: add the MCP79 support to hda_intel driver
From: "Peer Chen" <peerchen@gmail.com>

Add the MCP73/MCP77 support to hda driver.
The patch base on kernel 2.6.22-rc4

Signed-off-by: Peer Chen <peerchen@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN sound/pci/hda/hda_intel.c~alsa-add-the-mcp79-support-to-hda_intel-driver sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~alsa-add-the-mcp79-support-to-hda_intel-driver
+++ a/sound/pci/hda/hda_intel.c
@@ -1959,6 +1959,10 @@ static struct pci_device_id azx_ids[] = 
 	{ 0x10de, 0x0775, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
 	{ 0x10de, 0x0776, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
 	{ 0x10de, 0x0777, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
+	{ 0x10de, 0x0ac0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
+	{ 0x10de, 0x0ac1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
+	{ 0x10de, 0x0ac2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
+	{ 0x10de, 0x0ac3, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
_

Patches currently in -mm which might be from peerchen@gmail.com are

git-alsa.patch
ahci-add-mcp79-support-to-ahci-driver.patch
