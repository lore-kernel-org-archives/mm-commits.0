From: akpm@linux-foundation.org
Subject: - pciidsh-remove-a-duplicated-symbol.patch removed from -mm tree
Date: Thu, 07 Aug 2008 10:18:26 -0700
Message-ID: <200808071718.m77HIQut028531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbYHGRTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 13:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant_lkml@dodo.com.au, dougthompson@xmission.com, gcoady.lk@gmail.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci.ids.h: remove a duplicated symbol
has been removed from the -mm tree.  Its filename was
     pciidsh-remove-a-duplicated-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci.ids.h: remove a duplicated symbol
From: Grant Coady <grant_lkml@dodo.com.au>

pci.ids.h: remove a duplicated symbol

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/pci_ids.h~pciidsh-remove-a-duplicated-symbol include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pciidsh-remove-a-duplicated-symbol
+++ a/include/linux/pci_ids.h
@@ -2177,8 +2177,6 @@
 #define PCI_DEVICE_ID_HERC_WIN		0x5732
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
-#define PCI_VENDOR_ID_RDC		0x17f3
