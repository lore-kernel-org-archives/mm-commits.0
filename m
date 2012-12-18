From: akpm@linux-foundation.org
Subject: [merged] aoe-update-driver-internal-version-to-64.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:38 -0800
Message-ID: <20121218201038.9D5B1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39540 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2LRUKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:39 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so126101vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update driver-internal version to 64+
has been removed from the -mm tree.  Its filename was
     aoe-update-driver-internal-version-to-64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update driver-internal version to 64+

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-driver-internal-version-to-64 drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-driver-internal-version-to-64
+++ a/drivers/block/aoe/aoe.h
@@ -1,5 +1,6 @@
+
 /* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "60"
+#define VERSION "64+"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

