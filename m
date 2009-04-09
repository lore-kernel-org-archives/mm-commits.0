From: akpm@linux-foundation.org
Subject: + hp_accel-remove-unused-include-versionh.patch added to -mm tree
Date: Thu, 09 Apr 2009 13:25:24 -0700
Message-ID: <200904092025.n39KPOT9008338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761657AbZDIU1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 16:27:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, pavel@ucw.cz


The patch titled
     hp_accel: remove unused #include <version.h>
has been added to the -mm tree.  Its filename is
     hp_accel-remove-unused-include-versionh.patch

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
Subject: hp_accel: remove unused #include <version.h>
From: Huang Weiyi <weiyi.huang@gmail.com>

Remove unused #include <version.h> in drivers/hwmon/hp_accel.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/hwmon/hp_accel.c~hp_accel-remove-unused-include-versionh drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp_accel-remove-unused-include-versionh
+++ a/drivers/hwmon/hp_accel.c
@@ -34,7 +34,6 @@
 #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/freezer.h>
-#include <linux/version.h>
 #include <linux/uaccess.h>
 #include <linux/leds.h>
 #include <acpi/acpi_drivers.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
linux-next.patch
hp_accel-remove-unused-include-versionh.patch

