From: akpm@linux-foundation.org
Subject: + gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix.patch added to -mm tree
Date: Thu, 17 Sep 2009 20:38:24 -0700
Message-ID: <200909180338.n8I3cOC5026174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbZIRDiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Sep 2009 23:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alek.du@intel.com


The patch titled
     gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix
has been added to the -mm tree.  Its filename is
     gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix.patch

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

linux-next.patch
gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver.patch
gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix.patch
gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix-fix.patch
gpio-pca953x-add-support-for-max7315.patch

