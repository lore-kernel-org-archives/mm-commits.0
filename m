From: akpm@linux-foundation.org
Subject: + fix-jdelvare-i2c-i2c-at91-support-new-style-binding.patch added to -mm tree
Date: Wed, 09 May 2007 20:51:59 -0700
Message-ID: <200705100351.l4A3pxl4011367@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbXEJDwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 23:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, david-b@pacbell.net, khali@linux-fr.org


The patch titled
     i2c-at91: compile fix (IS_ERR)
has been added to the -mm tree.  Its filename is
     fix-jdelvare-i2c-i2c-at91-support-new-style-binding.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2c-at91: compile fix (IS_ERR)
From: Alexey Dobriyan <adobriyan@gmail.com>

  CC      drivers/i2c/busses/i2c-at91.o
drivers/i2c/busses/i2c-at91.c: In function 'at91_i2c_probe':
drivers/i2c/busses/i2c-at91.c:213: warning: implicit declaration of function 'IS_ERR'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-at91.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/i2c/busses/i2c-at91.c~fix-jdelvare-i2c-i2c-at91-support-new-style-binding drivers/i2c/busses/i2c-at91.c
--- a/drivers/i2c/busses/i2c-at91.c~fix-jdelvare-i2c-i2c-at91-support-new-style-binding
+++ a/drivers/i2c/busses/i2c-at91.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/delay.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-at91-support-new-style-binding.patch
pata_scc-fix-compilation.patch
git-parisc.patch
git-watchdog.patch
