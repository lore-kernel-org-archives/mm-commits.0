From: akpm@linux-foundation.org
Subject: - 8250-add-back-missing-space-from-banner-printk.patch removed from -mm tree
Date: Mon, 05 Jan 2009 01:22:27 -0800
Message-ID: <200901050922.n059MR07005387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbZAEJWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 04:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     8250: add back missing space from banner printk
has been removed from the -mm tree.  Its filename was
     8250-add-back-missing-space-from-banner-printk.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250: add back missing space from banner printk
From: "Will Newton" <will.newton@gmail.com>

A space went missing from the printk output at port initialization time,
add it back so the output is more readable.

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/8250.c~8250-add-back-missing-space-from-banner-printk drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-add-back-missing-space-from-banner-printk
+++ a/drivers/serial/8250.c
@@ -3123,7 +3123,7 @@ static int __init serial8250_init(void)
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
 
-	printk(KERN_INFO "Serial: 8250/16550 driver"
+	printk(KERN_INFO "Serial: 8250/16550 driver "
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
_

Patches currently in -mm which might be from will.newton@gmail.com are

origin.patch
8250-add-back-missing-space-from-banner-printk.patch

