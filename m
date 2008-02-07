From: akpm@linux-foundation.org
Subject: - char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:45 -0800
Message-ID: <200802070023.m170NQBY006521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934034AbYBGAoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     char: use SGI_HAS_DS1286 for SGI_DS1286 depends
has been removed from the -mm tree.  Its filename was
     char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: use SGI_HAS_DS1286 for SGI_DS1286 depends
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Use SGI_HAS_DS1286 for SGI_DS1286 depends

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~char-use-sgi_has_ds1286-for-sgi_ds1286-depends drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-use-sgi_has_ds1286-for-sgi_ds1286-depends
+++ a/drivers/char/Kconfig
@@ -765,7 +765,7 @@ config JS_RTC
 
 config SGI_DS1286
 	tristate "SGI DS1286 RTC support"
-	depends on SGI_IP22
+	depends on SGI_HAS_DS1286
 	help
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

origin.patch
git-scsi-misc.patch
git-watchdog.patch
