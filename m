From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-pch_phubc-add-module_device_table.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:49 -0700
Message-ID: <201103232042.p2NKgPZb028760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933407Ab1CWUnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, gregkh@suse.de, masa-korg@dsn.okisemi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/pch_phub.c: add MODULE_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     drivers-misc-pch_phubc-add-module_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/pch_phub.c: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/pch_phub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/pch_phub.c~drivers-misc-pch_phubc-add-module_device_table drivers/misc/pch_phub.c
--- a/drivers/misc/pch_phub.c~drivers-misc-pch_phubc-add-module_device_table
+++ a/drivers/misc/pch_phub.c
@@ -735,6 +735,7 @@ static struct pci_device_id pch_phub_pci
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7213_PHUB), 2,  },
 	{ }
 };
+MODULE_DEVICE_TABLE(pci, pch_phub_pcidev_id);
 
 static struct pci_driver pch_phub_driver = {
 	.name = "pch_phub",
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

