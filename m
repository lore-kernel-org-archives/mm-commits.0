From: akpm@linux-foundation.org
Subject: [merged] uio-add-module_device_table.patch removed from -mm tree
Date: Thu, 16 Apr 2009 13:09:49 -0700
Message-ID: <200904162009.n3GK9ni7022224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbZDPUMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 16:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hjk@linutronix.de, greg@kroah.com, vinkronald@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     uio: add MODULE_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     uio-add-module_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uio: add MODULE_DEVICE_TABLE
From: "Hans J. Koch" <hjk@linutronix.de>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13059

drivers/uio/uio_cif.c misses a MODULE_DEVICE_TABLE, this fixes it.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Reported-by: <vinkronald@hotmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uio/uio_cif.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/uio/uio_cif.c~uio-add-module_device_table drivers/uio/uio_cif.c
--- a/drivers/uio/uio_cif.c~uio-add-module_device_table
+++ a/drivers/uio/uio_cif.c
@@ -147,5 +147,6 @@ static void __exit hilscher_exit_module(
 module_init(hilscher_init_module);
 module_exit(hilscher_exit_module);
 
+MODULE_DEVICE_TABLE(pci, hilscher_pci_ids);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Hans J. Koch, Benedikt Spranger");
_

Patches currently in -mm which might be from hjk@linutronix.de are

linux-next.patch

