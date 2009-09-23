From: akpm@linux-foundation.org
Subject: [merged] of-remove-stmm25p40-alias.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:56 -0700
Message-ID: <200909231957.n8NJvu64007949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788AbZIWT7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.org, mm-commit


The patch titled
     of: remove "stm,m25p40" alias
has been removed from the -mm tree.  Its filename was
     of-remove-stmm25p40-alias.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: of: remove "stm,m25p40" alias
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The alias isn't needed any longer since the m25p80 driver converted to the
module device table matching.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/base.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/of/base.c~of-remove-stmm25p40-alias drivers/of/base.c
--- a/drivers/of/base.c~of-remove-stmm25p40-alias
+++ a/drivers/of/base.c
@@ -447,7 +447,6 @@ struct of_modalias_table {
 static struct of_modalias_table of_modalias_table[] = {
 	{ "fsl,mcu-mpc8349emitx", "mcu-mpc8349emitx" },
 	{ "mmc-spi-slot", "mmc_spi" },
-	{ "stm,m25p40", "m25p80" },
 };
 
 /**
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

