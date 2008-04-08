From: akpm@linux-foundation.org
Subject: + spi-spi_bfin5xx-build-fix.patch added to -mm tree
Date: Tue, 08 Apr 2008 00:53:57 -0700
Message-ID: <200804080753.m387rvDm015084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbYDHHyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 03:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin5xx build fix
has been added to the -mm tree.  Its filename is
     spi-spi_bfin5xx-build-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
spi-spi_bfin5xx-build-fix.patch
blackfin-replace-remaining-__function__-occurences.patch
git-watchdog.patch
nfs-nommu-fix-bug-executing-fdpic-elf-on-nfs-mount-triggers-bug-at-mm-nommuc-862-do_mmap_private.patch
procfs-task-exe-symlink-fix-2.patch

