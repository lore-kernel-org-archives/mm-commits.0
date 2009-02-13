From: akpm@linux-foundation.org
Subject: + hptiop-add-new-pci-device-id.patch added to -mm tree
Date: Fri, 13 Feb 2009 13:54:42 -0800
Message-ID: <200902132154.n1DLsgxX002762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761528AbZBMVys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 16:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@highpoint-tech.com, James.Bottomley@HansenPartnership.com


The patch titled
     hptiop: add new PCI device ID
has been added to the -mm tree.  Its filename is
     hptiop-add-new-pci-device-id.patch

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
Subject: hptiop: add new PCI device ID
From: HighPoint Linux Team <linux@highpoint-tech.com>

Add a new PCI device ID.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/hptiop.c~hptiop-add-new-pci-device-id drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-add-new-pci-device-id
+++ a/drivers/scsi/hptiop.c
@@ -1250,6 +1250,7 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
_

Patches currently in -mm which might be from linux@highpoint-tech.com are

hptiop-add-new-pci-device-id.patch

