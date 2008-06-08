From: akpm@linux-foundation.org
Subject: - hdaps-fix-module-loading-on-thinkpad-t61p.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:14 -0700
Message-ID: <200806081949.m58JnEve017643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbYFHTt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@canonical.com, khali@linux-fr.org, max@stro.at, mhoffman@lightlink.com, ubuntu@hjernemadsen.org, mm-commits@vger.kernel.org


The patch titled
     hdaps: fix module loading on Thinkpad T61P
has been removed from the -mm tree.  Its filename was
     hdaps-fix-module-loading-on-thinkpad-t61p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hdaps: fix module loading on Thinkpad T61P
From: Tim Gardner <tim.gardner@canonical.com>

Adds DMI system identifier for ThinkPad T61.

Originally written by Klaus S. Madsen.

Taken from http://launchpadlibrarian.net/10864950/hdaps-t61.patch

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: maximilian attems <max@stro.at>
Cc: Klaus S. Madsen <ubuntu@hjernemadsen.org>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hdaps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/hdaps.c~hdaps-fix-module-loading-on-thinkpad-t61p drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~hdaps-fix-module-loading-on-thinkpad-t61p
+++ a/drivers/hwmon/hdaps.c
@@ -522,6 +522,7 @@ static struct dmi_system_id __initdata h
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
_

Patches currently in -mm which might be from tim.gardner@canonical.com are

origin.patch

