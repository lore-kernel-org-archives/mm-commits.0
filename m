From: akpm@linux-foundation.org
Subject: + hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf.patch added to -mm tree
Date: Thu, 28 Oct 2010 14:28:57 -0700
Message-ID: <201010282128.o9SLSvq9022084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217Ab0J1V3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Oct 2010 17:29:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com


The patch titled
     hpsa: remove incorrect redefinition of PCI_DEVICE_ID_HP_CISSF
has been added to the -mm tree.  Its filename is
     hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: remove incorrect redefinition of PCI_DEVICE_ID_HP_CISSF
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It is defined correctly in pci_ids.h with the value 0x323b

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf
+++ a/drivers/scsi/hpsa.c
@@ -91,7 +91,6 @@ static const struct pci_device_id hpsa_p
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
-#define PCI_DEVICE_ID_HP_CISSF 0x333f
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
cciss-fix-botched-tag-masking-for-scsi-tape-commands.patch
hpsa-remove-incorrect-redefinition-of-pci_device_id_hp_cissf.patch

