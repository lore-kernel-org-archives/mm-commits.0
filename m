From: akpm@linux-foundation.org
Subject: + input-bf54x-keys-fix-typo.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:09:50 -0800
Message-ID: <200903062209.n26M9omq004576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbZCFWKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:10:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, dtor@mail.ru


The patch titled
     input: bf54x-keys: Fix typo
has been added to the -mm tree.  Its filename is
     input-bf54x-keys-fix-typo.patch

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

linux-next.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-ad7879-touchscreen-driver.patch
input-bf54x-keys-fix-typo.patch
usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch

