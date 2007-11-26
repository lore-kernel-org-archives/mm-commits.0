From: akpm@linux-foundation.org
Subject: - arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:48:18 -0800
Message-ID: <200711262148.lAQLmIr0024586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbXKZVs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:48:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     ARM: remove reference to non-existent MTD_OBSOLETE_CHIPS
has been removed from the -mm tree.  Its filename was
     arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM: remove reference to non-existent MTD_OBSOLETE_CHIPS
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

The CONFIG variable MTD_OBSOLETE_CHIPS was deleted in commit
ba7cc09c9c9e29a57045dc5bbf843ac1cfad3283.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/collie_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/arm/configs/collie_defconfig~arm-remove-reference-to-non-existent-mtd_obsolete_chips arch/arm/configs/collie_defconfig
--- a/arch/arm/configs/collie_defconfig~arm-remove-reference-to-non-existent-mtd_obsolete_chips
+++ a/arch/arm/configs/collie_defconfig
@@ -367,7 +367,6 @@ CONFIG_MTD_CFI_UTIL=y
 # CONFIG_MTD_RAM is not set
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-CONFIG_MTD_OBSOLETE_CHIPS=y
 CONFIG_MTD_SHARP=y
 # CONFIG_MTD_XIP is not set
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

git-arm.patch
git-hwmon.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
git-nfsd.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
a-few-corrections-to-include-linux-kbuild.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
