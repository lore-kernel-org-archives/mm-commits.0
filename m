From: akpm@linux-foundation.org
Subject: - cciss-add-new-hardware-support-fix.patch removed from -mm tree
Date: Thu, 12 Jun 2008 14:21:52 -0700
Message-ID: <200806122133.m5CLXZb7007773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbYFLVeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 17:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cciss-add-new-hardware-support fix
has been removed from the -mm tree.  Its filename was
     cciss-add-new-hardware-support-fix.patch

This patch was dropped because it was folded into cciss-add-new-hardware-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss-add-new-hardware-support fix
From: Mike Miller <mike.miller@hp.com>

Patch supercedes the previous 1/2. Busted, didn't compile test the previous
patch. :(

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/pci_ids.h~cciss-add-new-hardware-support-fix include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~cciss-add-new-hardware-support-fix
+++ a/include/linux/pci_ids.h
@@ -716,6 +716,7 @@
 #define PCI_DEVICE_ID_HP_CISSA		0x3220
 #define PCI_DEVICE_ID_HP_CISSC		0x3230
 #define PCI_DEVICE_ID_HP_CISSD		0x3238
+#define PCI_DEVICE_ID_HP_CISSE		0x323a
 #define PCI_DEVICE_ID_HP_ZX2_IOC	0x4031
 
 #define PCI_VENDOR_ID_PCTECH		0x1042
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-add-new-hardware-support.patch
cciss-add-new-hardware-support-fix.patch
cciss-bump-version-to-20-to-reflect-new-hw-support.patch

