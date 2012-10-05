From: akpm@linux-foundation.org
Subject: [merged] aoe-update-aoe-internal-version-number-to-50.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:13 -0700
Message-ID: <20121005202214.0F8F420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:45809 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:16 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98994lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update aoe-internal version number to 50
has been removed from the -mm tree.  Its filename was
     aoe-update-aoe-internal-version-number-to-50.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update aoe-internal version number to 50

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-aoe-internal-version-number-to-50 drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-aoe-internal-version-number-to-50
+++ a/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "49"
+#define VERSION "50"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

