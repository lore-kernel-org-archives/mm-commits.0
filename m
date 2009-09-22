From: akpm@linux-foundation.org
Subject: [folded] gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:50:12 -0700
Message-ID: <200909222150.n8MLoCO5014000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbZIVVuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:50:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alek.du@intel.com, mm-commits@vger.kernel.org


The patch titled
     gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix
has been removed from the -mm tree.  Its filename was
     gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix.patch

This patch was dropped because it was folded into gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix
From: Alek Du <alek.du@intel.com>

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/langwell_gpio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/langwell_gpio.c~gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix
+++ a/drivers/gpio/langwell_gpio.c
@@ -26,6 +26,7 @@
 #include <linux/stddef.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
 
_

Patches currently in -mm which might be from alek.du@intel.com are

gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver.patch
gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix.patch
gpio-pca953x-add-support-for-max7315.patch

