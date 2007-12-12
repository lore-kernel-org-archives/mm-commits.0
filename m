From: akpm@linux-foundation.org
Subject: + watchdog-use-sgi_has_indydog-for-indydog-depends.patch added to -mm tree
Date: Wed, 12 Dec 2007 02:34:37 -0800
Message-ID: <200712121034.lBCAYbQQ005425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237AbXLLKe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 05:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de, ralf@linux-mips.org, wim@iguana.be


The patch titled
     watchdog: use SGI_HAS_INDYDOG for INDYDOG depends
has been added to the -mm tree.  Its filename is
     watchdog-use-sgi_has_indydog-for-indydog-depends.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: watchdog: use SGI_HAS_INDYDOG for INDYDOG depends
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Use SGI_HAS_INDYDOG for INDYDOG depends.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/Kconfig~watchdog-use-sgi_has_indydog-for-indydog-depends drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~watchdog-use-sgi_has_indydog-for-indydog-depends
+++ a/drivers/watchdog/Kconfig
@@ -624,7 +624,7 @@ config SBC_EPX_C3_WATCHDOG
 
 config INDYDOG
 	tristate "Indy/I2 Hardware Watchdog"
-	depends on SGI_IP22
+	depends on SGI_HAS_INDYDOG
 	help
 	  Hardware driver for the Indy's/I2's watchdog. This is a
 	  watchdog timer that will reboot the machine after a 60 second
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

git-mips.patch
git-netdev-all.patch
watchdog-use-sgi_has_indydog-for-indydog-depends.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
partition-use-default_sgi_partition-for-sgi_partion-default.patch
