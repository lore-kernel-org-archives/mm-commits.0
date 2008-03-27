From: akpm@linux-foundation.org
Subject: - mmc-omap-remove-extra-divisor-increase.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:17:32 -0700
Message-ID: <200803270317.m2R3HW1D015154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168AbYC0DRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@atomide.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: remove extra divisor increase
has been removed from the -mm tree.  Its filename was
     mmc-omap-remove-extra-divisor-increase.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: remove extra divisor increase
From: Tony Lindgren <tony@atomide.com>

As noted by Kyungmin Park, the divisor calculation has an unnecessary
increase.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-remove-extra-divisor-increase drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-remove-extra-divisor-increase
+++ a/drivers/mmc/host/omap.c
@@ -931,7 +931,6 @@ static int mmc_omap_calc_divisor(struct 
 
 	if (dsor > 250)
 		dsor = 250;
-	dsor++;
 
 	if (ios->bus_width == MMC_BUS_WIDTH_4)
 		dsor |= 1 << 15;
_

Patches currently in -mm which might be from tony@atomide.com are

mmc-omap-remove-extra-divisor-increase.patch
mmc-omap-fix-the-byteblock-capability-removal.patch
mmc-omap-remove-cover-switch-handling-to-allow-adding-multislot-support.patch
mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch
mmc-omap-abort-stuck-commands.patch
mmc-omap-using-setup_timer-instead-of-init_timer.patch
mmc-omap-check-the-get_cover_state-function-pointer-if-not-set.patch
mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification.patch
mmc-omap-move-failing-command-abortion-to-workqueue.patch
mmc-omap-lazy-clock-shutdown.patch
mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

