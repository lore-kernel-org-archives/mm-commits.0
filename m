From: akpm@linux-foundation.org
Subject: [merged] hp_accel-remove-unused-include-versionh.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:31 -0700
Message-ID: <200904141948.n3EJmVA3019066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbZDNTum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     hp_accel: remove unused #include <version.h>
has been removed from the -mm tree.  Its filename was
     hp_accel-remove-unused-include-versionh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

