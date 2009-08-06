From: akpm@linux-foundation.org
Subject: [merged] drivers-parisc-lba_pcic-fix-faulty-check.patch removed from -mm tree
Date: Thu, 06 Aug 2009 13:31:29 -0700
Message-ID: <200908062031.n76KVTxe004822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756171AbZHFUcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 16:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgayda2@uiuc.edu, deller@gmx.de, grundler@parisc-linux.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     drivers/parisc/lba_pci.c: fix faulty check
has been removed from the -mm tree.  Its filename was
     drivers-parisc-lba_pcic-fix-faulty-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/parisc/lba_pci.c: fix faulty check
From: Stoyan Gaydarov <sgayda2@uiuc.edu>

Fix a spelling error that has resulted from copy and pasting.

The location of the error was found using a semantic patch but the
semantic patch was not trying to find these errors.  After looking things
over it seemed logical that this change was needed.

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/lba_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parisc/lba_pci.c~drivers-parisc-lba_pcic-fix-faulty-check drivers/parisc/lba_pci.c
--- a/drivers/parisc/lba_pci.c~drivers-parisc-lba_pcic-fix-faulty-check
+++ a/drivers/parisc/lba_pci.c
@@ -992,7 +992,7 @@ lba_pat_resources(struct parisc_device *
 		return;
 
 	io_pdc_cell = kzalloc(sizeof(pdc_pat_cell_mod_maddr_block_t), GFP_KERNEL);
-	if (!pa_pdc_cell) {
+	if (!io_pdc_cell) {
 		kfree(pa_pdc_cell);
 		return;
 	}
_

Patches currently in -mm which might be from sgayda2@uiuc.edu are

origin.patch
drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock.patch
linux-next.patch

