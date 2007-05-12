From: akpm@linux-foundation.org
Subject: - i2c-at91-compile-fix-is_err.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:42 -0700
Message-ID: <200705120515.l4C5Fgrh001770@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbXELFP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, david-b@pacbell.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c-at91: compile fix (IS_ERR)
has been removed from the -mm tree.  Its filename was
     i2c-at91-compile-fix-is_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2c-at91: compile fix (IS_ERR)
From: Alexey Dobriyan <adobriyan@gmail.com>

  CC      drivers/i2c/busses/i2c-at91.o
drivers/i2c/busses/i2c-at91.c: In function 'at91_i2c_probe':
drivers/i2c/busses/i2c-at91.c:213: warning: implicit declaration of function 'IS_ERR'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-at91.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/i2c/busses/i2c-at91.c~i2c-at91-compile-fix-is_err drivers/i2c/busses/i2c-at91.c
--- a/drivers/i2c/busses/i2c-at91.c~i2c-at91-compile-fix-is_err
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
git-parisc.patch
