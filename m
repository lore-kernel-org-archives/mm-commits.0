From: akpm@linux-foundation.org
Subject: + parport-driver-disable-pc-style-parport-on-blackfin-systems.patch added to -mm tree
Date: Tue, 18 Nov 2008 22:36:17 -0800
Message-ID: <200811190636.mAJ6aHJE018404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbYKSGg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 01:36:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org


The patch titled
     parport driver: disable pc-style parport on Blackfin systems
has been added to the -mm tree.  Its filename is
     parport-driver-disable-pc-style-parport-on-blackfin-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch
pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch
genrtc-disable-genrtc-on-blackfin-systems.patch
parport-driver-disable-pc-style-parport-on-blackfin-systems.patch

