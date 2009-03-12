From: akpm@linux-foundation.org
Subject: [merged] blackfin-serial-driver-bf538-9-linux-kernel-support.patch removed from -mm tree
Date: Thu, 12 Mar 2009 13:17:05 -0700
Message-ID: <200903122017.n2CKH5TG032630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbZCLUUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 16:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: bF538/9 Linux kernel Support
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-bf538-9-linux-kernel-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch

