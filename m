From: akpm@linux-foundation.org
Subject: - atl1-bump-version-number.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:04 -0800
Message-ID: <200702180215.l1I2F4al008354@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55646 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993096AbXBRCPH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     atl1: bump version number
has been removed from the -mm tree.  Its filename was
     atl1-bump-version-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1: bump version number
From: Jay Cliburn <jacliburn@bellsouth.net>

Bump the version number.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-bump-version-number drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-bump-version-number
+++ a/drivers/net/atl1/atl1_main.c
@@ -82,7 +82,7 @@
 
 #include "atl1.h"
 
-#define DRIVER_VERSION "2.0.6"
+#define DRIVER_VERSION "2.0.7"
 
 char atl1_driver_name[] = "atl1";
 static const char atl1_driver_string[] = "Attansic L1 Ethernet Network Driver";
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
git-netdev-all.patch
