From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-make-applesmc-load-automatically-on-startup.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:22 -0800
Message-ID: <200812021838.mB2IcMVO006854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106AbYLBSiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:38:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@bitmath.org, nicolas@boichat.ch, rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: make applesmc load automatically on startup
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-make-applesmc-load-automatically-on-startup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: make applesmc load automatically on startup
From: Henrik Rydberg <rydberg@bitmath.org>

make use of the new dmi device loading support to automatically load the
applesmc driver based on the dmi_match table.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-make-applesmc-load-automatically-on-startup drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-make-applesmc-load-automatically-on-startup
+++ a/drivers/hwmon/applesmc.c
@@ -1564,3 +1564,4 @@ module_exit(applesmc_exit);
 MODULE_AUTHOR("Nicolas Boichat");
 MODULE_DESCRIPTION("Apple SMC");
 MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
_

Patches currently in -mm which might be from rydberg@bitmath.org are


