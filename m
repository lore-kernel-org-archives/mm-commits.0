From: akpm@linux-foundation.org
Subject: - usb-hso-make-tty_operations-const.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:40 -0700
Message-ID: <200808122033.m7CKXea4011810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbYHLUe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@suse.de, ajb@spheresystems.co.uk, arjan@infradead.org, mm-commits@vger.kernel.org


The patch titled
     USB: HSO: make tty_operations const
has been removed from the -mm tree.  Its filename was
     usb-hso-make-tty_operations-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: USB: HSO: make tty_operations const
From: Greg Kroah-Hartman <gregkh@suse.de>

As recommended by Arjan.

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Bird <ajb@spheresystems.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/hso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/usb/hso.c~usb-hso-make-tty_operations-const drivers/net/usb/hso.c
--- a/drivers/net/usb/hso.c~usb-hso-make-tty_operations-const
+++ a/drivers/net/usb/hso.c
@@ -2725,7 +2725,7 @@ static int hso_mux_submit_intr_urb(struc
 }
 
 /* operations setup of the serial interface */
-static struct tty_operations hso_serial_ops = {
+static const struct tty_operations hso_serial_ops = {
 	.open = hso_serial_open,
 	.close = hso_serial_close,
 	.write = hso_serial_write,
_

Patches currently in -mm which might be from gregkh@suse.de are

origin.patch
linux-next.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch

