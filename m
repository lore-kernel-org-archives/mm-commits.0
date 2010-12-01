From: akpm@linux-foundation.org
Subject: [to-be-updated] hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf.patch removed from -mm tree
Date: Wed, 01 Dec 2010 14:51:40 -0800
Message-ID: <201012012251.oB1MpeZK016470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545Ab0LAWwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 17:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: remove incorrect redefinition of PCI_DEVICE_ID_HP_CISSF
has been removed from the -mm tree.  Its filename was
     hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: remove incorrect redefinition of PCI_DEVICE_ID_HP_CISSF
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It is defined correctly in pci_ids.h with the value 0x323b

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf
+++ a/drivers/scsi/hpsa.c
@@ -90,7 +90,6 @@ static const struct pci_device_id hpsa_p
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
-#define PCI_DEVICE_ID_HP_CISSF 0x333f
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

cciss-fix-botched-tag-masking-for-scsi-tape-commands.patch

