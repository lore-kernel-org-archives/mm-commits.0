From: akpm@linux-foundation.org
Subject: + ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids.patch added to -mm tree
Date: Tue, 19 Aug 2008 00:04:59 -0700
Message-ID: <200808190704.m7J74xwh003749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbYHSHFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 03:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seth.heasley@intel.com, jeff@garzik.org


The patch titled
     ata_piix: IDE mode SATA patch for Intel Ibex Peak DeviceIDs
has been added to the -mm tree.  Its filename is
     ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids.patch

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
Subject: ata_piix: IDE mode SATA patch for Intel Ibex Peak DeviceIDs
From: Seth Heasley <seth.heasley@intel.com>

Add the Intel Ibex Peak (PCH) IDE mode SATA Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/ata/ata_piix.c~ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids
+++ a/drivers/ata/ata_piix.c
@@ -275,6 +275,14 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (ICH10) */
 	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 
 	{ }	/* terminate list */
 };
_

Patches currently in -mm which might be from seth.heasley@intel.com are

linux-next.patch
ata_piix-ide-mode-sata-patch-for-intel-ibex-peak-deviceids.patch

