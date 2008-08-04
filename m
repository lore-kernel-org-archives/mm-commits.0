From: akpm@linux-foundation.org
Subject: - blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:51 -0700
Message-ID: <200808042006.m74K6pfk027727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759496AbYHDUHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin NFC Driver: enable Blackfin nand HWECC support by default
has been removed from the -mm tree.  Its filename was
     blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin NFC Driver: enable Blackfin nand HWECC support by default
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mtd/nand/Kconfig~blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default drivers/mtd/nand/Kconfig
--- a/drivers/mtd/nand/Kconfig~blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default
+++ a/drivers/mtd/nand/Kconfig
@@ -104,6 +104,7 @@ config MTD_NAND_BF5XX
 
 config MTD_NAND_BF5XX_HWECC
 	bool "BF5XX NAND Hardware ECC"
+	default y
 	depends on MTD_NAND_BF5XX
 	help
 	  Enable the use of the BF5XX's internal ECC generator when
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
blackfin-rtc-driver-add-support-for-power-management-framework.patch
blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch
blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch
blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch
blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch
blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch

