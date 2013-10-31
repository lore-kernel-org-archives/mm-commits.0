From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-hpsac-remove-unused-smart-array-id.patch
 removed from -mm tree
Date: Thu, 31 Oct 2013 10:59:53 -0700
Message-ID: <52729a99.ZsaemeS8b2z937DA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JaR7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 13:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.miller@hp.com

Subject: [merged] drivers-scsi-hpsac-remove-unused-smart-array-id.patch removed from -mm tree
To: mike.miller@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 10:59:53 -0700


The patch titled
     Subject: drivers/scsi/hpsa.c: remove unused Smart Array ID
has been removed from the -mm tree.  Its filename was
     drivers-scsi-hpsac-remove-unused-smart-array-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

