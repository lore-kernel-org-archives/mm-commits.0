From: akpm@linux-foundation.org
Subject: + blackfin-typo-config_rtc_bfin_module.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:03:13 -0800
Message-ID: <200711060003.lA603DJ6026635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574AbXKFADT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:03:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, bryan.wu@analog.com


The patch titled
     BLACKFIN: Typo: "CONFIG_RTC_BFIN_MODULE" ->  "CONFIG_RTC_DRV_BFIN_MODULE"
has been added to the -mm tree.  Its filename is
     blackfin-typo-config_rtc_bfin_module.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: BLACKFIN: Typo: "CONFIG_RTC_BFIN_MODULE" ->  "CONFIG_RTC_DRV_BFIN_MODULE"
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-bf533/boards/H8606.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/blackfin/mach-bf533/boards/H8606.c~blackfin-typo-config_rtc_bfin_module arch/blackfin/mach-bf533/boards/H8606.c
--- a/arch/blackfin/mach-bf533/boards/H8606.c~blackfin-typo-config_rtc_bfin_module
+++ a/arch/blackfin/mach-bf533/boards/H8606.c
@@ -49,7 +49,7 @@
  */
 const char bfin_board_name[] = "HV Sistemas H8606";
 
-#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_BFIN_MODULE)
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
 	.name = "rtc-bfin",
 	.id   = -1,
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
blackfin-typo-config_rtc_bfin_module.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
