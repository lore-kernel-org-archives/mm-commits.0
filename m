From: akpm@linux-foundation.org
Subject: - parport-driver-disable-pc-style-parport-on-blackfin-systems.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:44:04 -0800
Message-ID: <200811202044.mAKKi4mQ007858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579AbYKTUoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:44:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     parport driver: disable pc-style parport on Blackfin systems
has been removed from the -mm tree.  Its filename was
     parport-driver-disable-pc-style-parport-on-blackfin-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport driver: disable pc-style parport on Blackfin systems
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/Kconfig~parport-driver-disable-pc-style-parport-on-blackfin-systems drivers/parport/Kconfig
--- a/drivers/parport/Kconfig~parport-driver-disable-pc-style-parport-on-blackfin-systems
+++ a/drivers/parport/Kconfig
@@ -36,7 +36,7 @@ if PARPORT
 config PARPORT_PC
 	tristate "PC-style hardware"
 	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
-		(!M68K || ISA) && !MN10300 && !AVR32
+		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch
physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch
pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch
genrtc-disable-genrtc-on-blackfin-systems.patch

