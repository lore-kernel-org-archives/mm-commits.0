From: akpm@linux-foundation.org
Subject: [merged] mfd-pcf50633-gpioc-add-module_license.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:23 -0700
Message-ID: <200905171654.n4HGsNV1017078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbZEQQ4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, andy@openmoko.com, balajirrao@openmoko.org, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd/pcf50633-gpio.c: add MODULE_LICENSE
has been removed from the -mm tree.  Its filename was
     mfd-pcf50633-gpioc-add-module_license.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd/pcf50633-gpio.c: add MODULE_LICENSE
From: Adrian Bunk <bunk@kernel.org>

Add the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/pcf50633-gpio.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/mfd/pcf50633-gpio.c~mfd-pcf50633-gpioc-add-module_license drivers/mfd/pcf50633-gpio.c
--- a/drivers/mfd/pcf50633-gpio.c~mfd-pcf50633-gpioc-add-module_license
+++ a/drivers/mfd/pcf50633-gpio.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/gpio.h>
@@ -116,3 +117,5 @@ int pcf50633_gpio_power_supply_set(struc
 	return pcf50633_reg_set_bit_mask(pcf, reg, mask, val);
 }
 EXPORT_SYMBOL_GPL(pcf50633_gpio_power_supply_set);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from bunk@kernel.org are

linux-next.patch
reiser4.patch

