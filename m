From: akpm@linux-foundation.org
Subject: - drivers-serial-s3c2410c-remove-dead-config-symbols.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:36 -0800
Message-ID: <200802052227.m15MRHoA011763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762108AbYBEWof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, alan@redhat.com, ben@fluff.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/serial/s3c2410.c: remove dead config symbols
has been removed from the -mm tree.  Its filename was
     drivers-serial-s3c2410c-remove-dead-config-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/serial/s3c2410.c: remove dead config symbols
From: Jiri Olsa <olsajiri@gmail.com>

Remove dead config symbol.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ben Dooks <ben@fluff.org>
Cc: Alan Cox <alan@redhat.com>
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

origin.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
