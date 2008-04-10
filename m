From: akpm@linux-foundation.org
Subject: - spi-spi_bfin5xx-build-fix.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:00 -0700
Message-ID: <200804102001.m3AK10NZ014935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756757AbYDJUB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_bfin5xx build fix
has been removed from the -mm tree.  Its filename was
     spi-spi_bfin5xx-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_bfin5xx build fix
From: Mike Frysinger <vapier.adi@gmail.com>

Fix breakage cause by overzealous line wrapping; there should be only one
format string.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin5xx-build-fix drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin5xx-build-fix
+++ a/drivers/spi/spi_bfin5xx.c
@@ -713,8 +713,8 @@ static void pump_transfers(unsigned long
 	} else {
 		drv_data->len = transfer->len;
 	}
-	dev_dbg(&drv_data->pdev->dev, "transfer: ",
-		"drv_data->write is %p, chip->write is %p, null_wr is %p\n",
+	dev_dbg(&drv_data->pdev->dev,
+		"transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
 		drv_data->write, chip->write, null_writer);
 
 	/* speed and width has been set on per message */
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
blackfin-replace-remaining-__function__-occurences.patch
git-watchdog.patch
procfs-task-exe-symlink-fix-2.patch

