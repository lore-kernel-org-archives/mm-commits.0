From: akpm@linux-foundation.org
Subject: + drivers-serial-s3c2410c-remove-dead-config-symbols.patch added to -mm tree
Date: Thu, 08 Nov 2007 09:37:46 -0800
Message-ID: <200711081737.lA8Hblin006357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759924AbXKHRi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 12:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, rmk@arm.linux.org.uk


The patch titled
     drivers/serial/s3c2410.c: remove dead config symbols
has been added to the -mm tree.  Its filename is
     drivers-serial-s3c2410c-remove-dead-config-symbols.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/serial/s3c2410.c: remove dead config symbols
From: Jiri Olsa <olsajiri@gmail.com>

Remove dead config symbol.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/s3c2410.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/s3c2410.c~drivers-serial-s3c2410c-remove-dead-config-symbols drivers/serial/s3c2410.c
--- a/drivers/serial/s3c2410.c~drivers-serial-s3c2410c-remove-dead-config-symbols
+++ a/drivers/serial/s3c2410.c
@@ -1527,7 +1527,7 @@ static inline void s3c2440_serial_exit(v
 #define s3c2440_uart_inf_at NULL
 #endif /* CONFIG_CPU_S3C2440 */
 
-#if defined(CONFIG_CPU_S3C2412) || defined(CONFIG_CPU_S3C2413)
+#if defined(CONFIG_CPU_S3C2412)
 
 static int s3c2412_serial_setsource(struct uart_port *port,
 				     struct s3c24xx_uart_clksrc *clk)
_

Patches currently in -mm which might be from olsajiri@gmail.com are

drivers-serial-s3c2410c-remove-dead-config-symbols.patch
blackfin-remove-dead-config-symbol-from-blackfin-code.patch
