From: akpm@linux-foundation.org
Subject: - char-stallion-remove-user-class-report-request.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:34 -0700
Message-ID: <200707172306.l6HN6YZ4012032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091AbXGQXPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, remove user class report request
has been removed from the -mm tree.  Its filename was
     char-stallion-remove-user-class-report-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, remove user class report request
From: Jiri Slaby <jirislaby@gmail.com>

stallion, remove user class report request

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-remove-user-class-report-request drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-remove-user-class-report-request
+++ a/drivers/char/stallion.c
@@ -2357,9 +2357,6 @@ static int __devinit stl_pciprobe(struct
 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
 		goto err;
 
-	dev_info(&pdev->dev, "please, report this to LKML: %x/%x/%x\n",
-			pdev->vendor, pdev->device, pdev->class);
-
 	retval = pci_enable_device(pdev);
 	if (retval)
 		goto err;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
