From: akpm@linux-foundation.org
Subject: [merged] leds-add-missing-include-of-linux-moduleh.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:46 -0700
Message-ID: <201108261903.p7QJ3U3P005701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532Ab1HZTEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, damm@opensource.se, kristoffer.ericson@gmail.com, noodles@earth.li, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: add missing include of linux/module.h
has been removed from the -mm tree.  Its filename was
     leds-add-missing-include-of-linux-moduleh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: add missing include of linux/module.h
From: Axel Lin <axel.lin@gmail.com>

Add missing include of linux/module.h for drivers that use interfaces from
linux/module.h.  This patch fixes build errors.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Jonathan McDowell <noodles@earth.li>
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-ams-delta.c |    1 +
 drivers/leds/leds-hp6xx.c     |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/leds/leds-ams-delta.c~leds-add-missing-include-of-linux-moduleh drivers/leds/leds-ams-delta.c
--- a/drivers/leds/leds-ams-delta.c~leds-add-missing-include-of-linux-moduleh
+++ a/drivers/leds/leds-ams-delta.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
diff -puN drivers/leds/leds-hp6xx.c~leds-add-missing-include-of-linux-moduleh drivers/leds/leds-hp6xx.c
--- a/drivers/leds/leds-hp6xx.c~leds-add-missing-include-of-linux-moduleh
+++ a/drivers/leds/leds-hp6xx.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

