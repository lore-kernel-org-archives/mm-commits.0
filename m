From: akpm@linux-foundation.org
Subject: - blackfin-typo-config_rtc_bfin_module.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:37 -0800
Message-ID: <200711272033.lARKXbIS028991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755892AbXK0Udt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     BLACKFIN: Typo: "CONFIG_RTC_BFIN_MODULE" ->  "CONFIG_RTC_DRV_BFIN_MODULE"
has been removed from the -mm tree.  Its filename was
     blackfin-typo-config_rtc_bfin_module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-arm.patch
git-hwmon.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
git-nfsd.patch
git-xfs.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
a-few-corrections-to-include-linux-kbuild.patch
ncpfs-update-diagnostic-strings-to-match-routine-names.patch
hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
