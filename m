From: akpm@linux-foundation.org
Subject: [merged] hptiop-add-new-pci-device-id.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:33:23 -0800
Message-ID: <200902241933.n1OJXNBW004521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758927AbZBXThF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:37:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@highpoint-tech.com, James.Bottomley@HansenPartnership.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hptiop: add new PCI device ID
has been removed from the -mm tree.  Its filename was
     hptiop-add-new-pci-device-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hptiop: add new PCI device ID
From: HighPoint Linux Team <linux@highpoint-tech.com>

Add a new PCI device ID.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/hptiop.c~hptiop-add-new-pci-device-id drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-add-new-pci-device-id
+++ a/drivers/scsi/hptiop.c
@@ -1251,6 +1251,7 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
_

Patches currently in -mm which might be from linux@highpoint-tech.com are

linux-next.patch

