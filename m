From: akpm@linux-foundation.org
Subject: + mtd-correct-misspelled-preprocessor-variable.patch added to -mm tree
Date: Wed, 07 Mar 2007 15:59:14 -0800
Message-ID: <200703072359.l27NxEMR013667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39741 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992770AbXCGX7X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:59:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, dwmw2@infradead.org


The patch titled
     MTD: Correct misspelled preprocessor variable  "MTD_NAND_DISKONCHIP_BBTWRITE".
has been added to the -mm tree.  Its filename is
     mtd-correct-misspelled-preprocessor-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MTD: Correct misspelled preprocessor variable  "MTD_NAND_DISKONCHIP_BBTWRITE".
From: "Robert P. J. Day" <rpjday@mindspring.com>

  Replace the apparently misspelled preprocessor variable
"MTD_NAND_DISKONCHIP_BBTWRITE" with the correct form
"CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/diskonchip.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/diskonchip.c~mtd-correct-misspelled-preprocessor-variable drivers/mtd/nand/diskonchip.c
--- a/drivers/mtd/nand/diskonchip.c~mtd-correct-misspelled-preprocessor-variable
+++ a/drivers/mtd/nand/diskonchip.c
@@ -114,7 +114,7 @@ module_param(no_autopart, int, 0);
 static int show_firmware_partition = 0;
 module_param(show_firmware_partition, int, 0);
 
-#ifdef MTD_NAND_DISKONCHIP_BBTWRITE
+#ifdef CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE
 static int inftl_bbt_write = 1;
 #else
 static int inftl_bbt_write = 0;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
mtd-correct-misspelled-preprocessor-variable.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
