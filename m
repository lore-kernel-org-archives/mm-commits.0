From: akpm@linux-foundation.org
Subject: - hptiop-add-more-pci-device-ids.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:18:11 -0700
Message-ID: <200807301918.m6UJIBgK011278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYG3TTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@highpoint-tech.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hptiop: add more PCI device IDs
has been removed from the -mm tree.  Its filename was
     hptiop-add-more-pci-device-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hptiop: add more PCI device IDs
From: HighPoint Linux Team <linux@highpoint-tech.com>

Add PCI device ID for new adapter models.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/scsi/hptiop.c~hptiop-add-more-pci-device-ids drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-add-more-pci-device-ids
+++ a/drivers/scsi/hptiop.c
@@ -1249,6 +1249,13 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3522), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4311), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3120), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3122), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },
_

Patches currently in -mm which might be from linux@highpoint-tech.com are

git-scsi-rc-fixes.patch

