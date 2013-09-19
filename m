From: akpm@linux-foundation.org
Subject: + drivers-scsi-hpsac-remove-unused-smart-array-id.patch added to
 -mm tree
Date: Thu, 19 Sep 2013 16:33:58 -0700
Message-ID: <523b89e6.oVxgfiSA/RWaEyVb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISXd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.miller@hp.com

Subject: + drivers-scsi-hpsac-remove-unused-smart-array-id.patch added to -mm tree
To: mike.miller@hp.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:33:58 -0700


The patch titled
     Subject: drivers/scsi/hpsa.c: remove unused Smart Array ID
has been added to the -mm tree.  Its filename is
     drivers-scsi-hpsac-remove-unused-smart-array-id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-scsi-hpsac-remove-unused-smart-array-id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-scsi-hpsac-remove-unused-smart-array-id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Miller <mike.miller@hp.com>
Subject: drivers/scsi/hpsa.c: remove unused Smart Array ID

Remove the PCI ID of a cancelled Smart Array.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~drivers-scsi-hpsac-remove-unused-smart-array-id drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~drivers-scsi-hpsac-remove-unused-smart-array-id
+++ a/drivers/scsi/hpsa.c
@@ -100,7 +100,6 @@ static const struct pci_device_id hpsa_p
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
_

Patches currently in -mm which might be from mike.miller@hp.com are

drivers-scsi-hpsac-remove-unused-smart-array-id.patch

