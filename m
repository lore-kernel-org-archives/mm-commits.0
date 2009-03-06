From: akpm@linux-foundation.org
Subject: + blackfin-serial-driver-bf538-9-linux-kernel-support.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:37:16 -0800
Message-ID: <200903062237.n26MbGhd007034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024AbZCFWiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:38:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org


The patch titled
     blackfin serial driver: bF538/9 Linux kernel Support
has been added to the -mm tree.  Its filename is
     blackfin-serial-driver-bf538-9-linux-kernel-support.patch

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
Subject: blackfin serial driver: bF538/9 Linux kernel Support
From: Michael Hennerich <michael.hennerich@analog.com>

Enable third UART on BF538/9

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/Kconfig~blackfin-serial-driver-bf538-9-linux-kernel-support drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~blackfin-serial-driver-bf538-9-linux-kernel-support
+++ a/drivers/serial/Kconfig
@@ -770,7 +770,7 @@ config UART1_RTS_PIN
 
 config SERIAL_BFIN_UART2
 	bool "Enable UART2"
-	depends on SERIAL_BFIN && (BF54x)
+	depends on SERIAL_BFIN && (BF54x || BF538 || BF539)
 	help
 	  Enable UART2
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-ad7879-touchscreen-driver.patch
input-bf54x-keys-fix-typo.patch
usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch
blackfin-serial-driver-bf538-9-linux-kernel-support.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch

