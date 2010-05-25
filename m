From: akpm@linux-foundation.org
Subject: + nuc900-add-maintainer-entries-for-wan-zongshun.patch added to -mm tree
Date: Tue, 25 May 2010 16:01:35 -0700
Message-ID: <201005252301.o4PN1Zti020200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758766Ab0EYXCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 19:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com


The patch titled
     nuc900: add maintainer entries for Wan ZongShun
has been added to the -mm tree.  Its filename is
     nuc900-add-maintainer-entries-for-wan-zongshun.patch

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
Subject: nuc900: add maintainer entries for Wan ZongShun
From: Wan ZongShun <mcuos.com@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN MAINTAINERS~nuc900-add-maintainer-entries-for-wan-zongshun MAINTAINERS
--- a/MAINTAINERS~nuc900-add-maintainer-entries-for-wan-zongshun
+++ a/MAINTAINERS
@@ -970,6 +970,18 @@ M:	Wan ZongShun <mcuos.com@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.mcuos.com
 S:	Maintained
+F:	arch/arm/mach-w90x900/
+F:	arch/arm/mach-nuc93x/
+F:	drivers/input/keyboard/w90p910_keypad.c
+F:	drivers/input/touchscreen/w90p910_ts.c
+F:	drivers/watchdog/nuc900_wdt.c
+F:	drivers/net/arm/w90p910_ether.c
+F:	drivers/mtd/nand/w90p910_nand.c
+F:	drivers/rtc/rtc-nuc900.c
+F:	drivers/spi/spi_nuc900.c
+F:	drivers/usb/host/ehci-w90x900.c
+F:	drivers/video/nuc900fb.c
+F:	drivers/sound/soc/nuc900/
 
 ARM/U300 MACHINE SUPPORT
 M:	Linus Walleij <linus.walleij@stericsson.com>
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

origin.patch
nuc900-add-maintainer-entries-for-wan-zongshun.patch
linux-next.patch

