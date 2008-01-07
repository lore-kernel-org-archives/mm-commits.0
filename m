From: akpm@linux-foundation.org
Subject: - watchdog-use-sgi_has_indydog-for-indydog-depends.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:54 -0800
Message-ID: <200801072139.m07LdYrR013574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbYAGVmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:42:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, ralf@linux-mips.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: use SGI_HAS_INDYDOG for INDYDOG depends
has been removed from the -mm tree.  Its filename was
     watchdog-use-sgi_has_indydog-for-indydog-depends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch
git-mips.patch
git-netdev-all.patch
git-watchdog.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
partition-use-default_sgi_partition-for-sgi_partion-default.patch
