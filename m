From: akpm@linux-foundation.org
Subject: + 8250-add-back-missing-space-from-banner-printk.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:51:36 -0800
Message-ID: <200812070751.mB77paRF007863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbYLGHvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:51:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     8250: add back missing space from banner printk
has been added to the -mm tree.  Its filename is
     8250-add-back-missing-space-from-banner-printk.patch

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
@@ -3018,7 +3018,7 @@ static int __init serial8250_init(void)
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
 
-	printk(KERN_INFO "Serial: 8250/16550 driver"
+	printk(KERN_INFO "Serial: 8250/16550 driver "
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
_

Patches currently in -mm which might be from will.newton@gmail.com are

linux-next.patch
8250-add-back-missing-space-from-banner-printk.patch

