From: akpm@linux-foundation.org
Subject: + s5pc110-sdhci-s3c-support-on-s5pc110.patch added to -mm tree
Date: Thu, 10 Jun 2010 13:43:17 -0700
Message-ID: <201006102043.o5AKhHK1022728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759702Ab0FJUnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 16:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kmpark@infradead.org, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     s5pc110: SDHCI-s3c support on s5pc110
has been added to the -mm tree.  Its filename is
     s5pc110-sdhci-s3c-support-on-s5pc110.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s5pc110: SDHCI-s3c support on s5pc110
From: Kyungmin Park <kmpark@infradead.org>

s5pc110 (aka s5pv210) uses the same SDHCI IP.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/Kconfig~s5pc110-sdhci-s3c-support-on-s5pc110 drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~s5pc110-sdhci-s3c-support-on-s5pc110
+++ a/drivers/mmc/host/Kconfig
@@ -123,7 +123,7 @@ config MMC_SDHCI_PLTFM
 
 config MMC_SDHCI_S3C
 	tristate "SDHCI support on Samsung S3C SoC"
-	depends on MMC_SDHCI && (PLAT_S3C24XX || PLAT_S3C64XX)
+	depends on MMC_SDHCI && PLAT_SAMSUNG
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  often referrered to as the HSMMC block in some of the Samsung S3C
_

Patches currently in -mm which might be from kmpark@infradead.org are

mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
s5pc110-sdhci-s3c-can-override-host-capabilities.patch
s5pc110-sdhci-s3c-support-on-s5pc110.patch
sdhci-add-no-hi-speed-bit-quirk-support.patch

