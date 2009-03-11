From: akpm@linux-foundation.org
Subject: [merged] input-bf54x-keys-fix-typo.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:10:07 -0700
Message-ID: <200903111810.n2BIA7c8020046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbZCKSSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: bf54x-keys: Fix typo
has been removed from the -mm tree.  Its filename was
     input-bf54x-keys-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: bf54x-keys: Fix typo
From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/bf54x-keys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/keyboard/bf54x-keys.c~input-bf54x-keys-fix-typo drivers/input/keyboard/bf54x-keys.c
--- a/drivers/input/keyboard/bf54x-keys.c~input-bf54x-keys-fix-typo
+++ a/drivers/input/keyboard/bf54x-keys.c
@@ -212,7 +212,7 @@ static int __devinit bfin_kpad_probe(str
 	if (!pdata->debounce_time || pdata->debounce_time > MAX_MULT ||
 	    !pdata->coldrive_time || pdata->coldrive_time > MAX_MULT) {
 		printk(KERN_ERR DRV_NAME
-			": Invalid Debounce/Columdrive Time from pdata\n");
+			": Invalid Debounce/Columndrive Time from platform data\n");
 		bfin_write_KPAD_MSEL(0xFF0);	/* Default MSEL	*/
 	} else {
 		bfin_write_KPAD_MSEL(
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch
usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch
blackfin-serial-driver-bf538-9-linux-kernel-support.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch

