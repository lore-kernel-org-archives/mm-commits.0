From: akpm@linux-foundation.org
Subject: - mtd-correct-misspelled-preprocessor-variable.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:34 -0800
Message-ID: <200703152158.l2FLwYTY027739@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXCOV6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MTD: Correct misspelled preprocessor variable  "MTD_NAND_DISKONCHIP_BBTWRITE".
has been removed from the -mm tree.  Its filename was
     mtd-correct-misspelled-preprocessor-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-avr32.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
ppc-correct-apparently-misspelled-xmon-preprocessor.patch
git-drm.patch
git-mtd.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
git-scsi-misc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-include-linux-elfnoteh.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
