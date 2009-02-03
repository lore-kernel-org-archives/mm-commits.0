From: akpm@linux-foundation.org
Subject: [merged] mtd-remove-eol-from-module_description.patch removed from -mm tree
Date: Tue, 03 Feb 2009 11:54:38 -0800
Message-ID: <200902031954.n13JscnR027324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbZBCTzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 14:55:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: niels.devos@wincor-nixdorf.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MTD: remove EOL from MODULE_DESCRIPTION
has been removed from the -mm tree.  Its filename was
     mtd-remove-eol-from-module_description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MTD: remove EOL from MODULE_DESCRIPTION
From: Niels de Vos <niels.devos@wincor-nixdorf.com>

There is no need to have a "\n" on a MODULE_DESCRIPTION, remove it.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/diskonchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/diskonchip.c~mtd-remove-eol-from-module_description drivers/mtd/nand/diskonchip.c
--- a/drivers/mtd/nand/diskonchip.c~mtd-remove-eol-from-module_description
+++ a/drivers/mtd/nand/diskonchip.c
@@ -1773,4 +1773,4 @@ module_exit(cleanup_nanddoc);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-MODULE_DESCRIPTION("M-Systems DiskOnChip 2000, Millennium and Millennium Plus device driver\n");
+MODULE_DESCRIPTION("M-Systems DiskOnChip 2000, Millennium and Millennium Plus device driver");
_

Patches currently in -mm which might be from niels.devos@wincor-nixdorf.com are

linux-next.patch

