From: akpm@linux-foundation.org
Subject: - mmc-omap-add-missing-newline.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:40 -0700
Message-ID: <200705031930.l43JUeo9018204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767851AbXECTdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: carlos.aguiar@indt.org.br, arnaud.patard@rtp-net.org, drzeus@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     MMC: OMAP: Add missing newline
has been removed from the -mm tree.  Its filename was
     mmc-omap-add-missing-newline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MMC: OMAP: Add missing newline
From: Carlos Aguiar <carlos.aguiar@indt.org.br>

Add a missing '\n' at the end of the 'cover is open' string in
mmc_omap_switch_handler().

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-add-missing-newline drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-add-missing-newline
+++ a/drivers/mmc/host/omap.c
@@ -604,7 +604,7 @@ static void mmc_omap_switch_handler(stru
 	}
 	if (mmc_omap_cover_is_open(host)) {
 		if (!complained) {
-			dev_info(mmc_dev(host->mmc), "cover is open");
+			dev_info(mmc_dev(host->mmc), "cover is open\n");
 			complained = 1;
 		}
 		if (mmc_omap_enable_poll)
_

Patches currently in -mm which might be from carlos.aguiar@indt.org.br are
