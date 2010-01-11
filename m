From: akpm@linux-foundation.org
Subject: [merged] mmc-allow-for-mmc-v44.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:44 -0800
Message-ID: <201001112018.o0BKIiJa025509__42436.376019805$1263241922$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab0AKUbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:31:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: allow for MMC v4.4
has been removed from the -mm tree.  Its filename was
     mmc-allow-for-mmc-v44.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: allow for MMC v4.4
From: Adrian Hunter <adrian.hunter@nokia.com>

JEDEC eMMC specification version 4.4 (MMCA 4.4) defines Extended CSD
structure versions up to 5.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/core/mmc.c~mmc-allow-for-mmc-v44 drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-allow-for-mmc-v44
+++ a/drivers/mmc/core/mmc.c
@@ -207,7 +207,7 @@ static int mmc_read_ext_csd(struct mmc_c
 	}
 
 	card->ext_csd.rev = ext_csd[EXT_CSD_REV];
-	if (card->ext_csd.rev > 3) {
+	if (card->ext_csd.rev > 5) {
 		printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
 			"version %d\n", mmc_hostname(card->host),
 			card->ext_csd.rev);
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

origin.patch

