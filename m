From: akpm@linux-foundation.org
Subject: + mmc-sdhci_int_data_mask-typo-error.patch added to -mm tree
Date: Thu, 29 Apr 2010 15:26:32 -0700
Message-ID: <201004292226.o3TMQW9M015239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932705Ab0D3RIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zgao6@marvell.com, linux-mmc@vger.kernel.org, matt@console-pimps.org


The patch titled
     mmc: SDHCI_INT_DATA_MASK typo error
has been added to the -mm tree.  Its filename is
     mmc-sdhci_int_data_mask-typo-error.patch

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
Subject: mmc: SDHCI_INT_DATA_MASK typo error
From: Zhangfei Gao <zgao6@marvell.com>

Signed-off-by: Zhangfei Gao <zgao6@marvell.com>
Reviewed-by: Matt Fleming <matt@console-pimps.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.h~mmc-sdhci_int_data_mask-typo-error drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~mmc-sdhci_int_data_mask-typo-error
+++ a/drivers/mmc/host/sdhci.h
@@ -127,7 +127,7 @@
 #define  SDHCI_INT_DATA_MASK	(SDHCI_INT_DATA_END | SDHCI_INT_DMA_END | \
 		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL | \
 		SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_DATA_CRC | \
-		SDHCI_INT_DATA_END_BIT | SDHCI_ADMA_ERROR)
+		SDHCI_INT_DATA_END_BIT | SDHCI_INT_ADMA_ERROR)
 #define SDHCI_INT_ALL_MASK	((unsigned int)-1)
 
 #define SDHCI_ACMD12_ERR	0x3C
_

Patches currently in -mm which might be from zgao6@marvell.com are

mmc-sdhci_int_data_mask-typo-error.patch

