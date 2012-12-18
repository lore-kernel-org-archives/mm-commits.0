From: akpm@linux-foundation.org
Subject: [merged] aoe-update-driver-internal-version-number-to-60.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:02 -0800
Message-ID: <20121218201002.A2592100056@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:33588 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:03 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so126048yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update driver-internal version number to 60
has been removed from the -mm tree.  Its filename was
     aoe-update-driver-internal-version-number-to-60.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update driver-internal version number to 60

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-driver-internal-version-number-to-60 drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-driver-internal-version-number-to-60
+++ a/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "50"
+#define VERSION "60"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

