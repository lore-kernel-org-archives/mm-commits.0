From: akpm@linux-foundation.org
Subject: + maintainers-some-atmel-drivers-change-maintainer.patch added to -mm tree
Date: Fri, 18 Jun 2010 15:03:45 -0700
Message-ID: <201006182203.o5IM3jYN025920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470Ab0FRWDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 18:03:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, avictor.za@gmail.com, haavard.skinnemoen@atmel.com, hskinnemoen@atmel.com


The patch titled
     MAINTAINERS: some Atmel drivers change maintainer
has been added to the -mm tree.  Its filename is
     maintainers-some-atmel-drivers-change-maintainer.patch

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
Subject: MAINTAINERS: some Atmel drivers change maintainer
From: Nicolas Ferre <nicolas.ferre@atmel.com>

I take over the maintenance of SPI, USART, Ethernet and USB gadget
drivers.  Those drivers are found in Atmel microcontrollers, both
AT32/AVR32 and AT91/ARM.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-some-atmel-drivers-change-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-some-atmel-drivers-change-maintainer
+++ a/MAINTAINERS
@@ -1151,7 +1151,7 @@ F:	drivers/mmc/host/atmel-mci.c
 F:	drivers/mmc/host/atmel-mci-regs.h
 
 ATMEL AT91 / AT32 SERIAL DRIVER
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/serial/atmel_serial.c
 
@@ -1163,18 +1163,18 @@ F:	drivers/video/atmel_lcdfb.c
 F:	include/video/atmel_lcdc.h
 
 ATMEL MACB ETHERNET DRIVER
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/net/macb.*
 
 ATMEL SPI DRIVER
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/spi/atmel_spi.*
 
 ATMEL USBA UDC DRIVER
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
-L:	kernel@avr32linux.org
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://avr32linux.org/twiki/bin/view/Main/AtmelUsbDeviceDriver
 S:	Supported
 F:	drivers/usb/gadget/atmel_usba_udc.*
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
maintainers-some-atmel-drivers-change-maintainer.patch

