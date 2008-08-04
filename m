From: akpm@linux-foundation.org
Subject: - drivers-base-driverc-remove-unused-to_dev-macro.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:15 -0700
Message-ID: <200808042006.m74K6Fgn027668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758295AbYHDUGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/base/driver.c: remove unused to_dev() macro
has been removed from the -mm tree.  Its filename was
     drivers-base-driverc-remove-unused-to_dev-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/base/driver.c: remove unused to_dev() macro
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/driver.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/base/driver.c~drivers-base-driverc-remove-unused-to_dev-macro drivers/base/driver.c
--- a/drivers/base/driver.c~drivers-base-driverc-remove-unused-to_dev-macro
+++ a/drivers/base/driver.c
@@ -16,9 +16,6 @@
 #include <linux/string.h>
 #include "base.h"
 
-#define to_dev(node) container_of(node, struct device, driver_list)
-
