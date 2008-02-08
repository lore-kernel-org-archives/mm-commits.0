From: akpm@linux-foundation.org
Subject: - aoe-bring-driver-version-number-to-47.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:47 -0800
Message-ID: <200802082015.m18KFSIX010601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755552AbYBHUqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     aoe: bring driver version number to 47
has been removed from the -mm tree.  Its filename was
     aoe-bring-driver-version-number-to-47.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: bring driver version number to 47
From: "Ed L. Cashin" <ecashin@coraid.com>

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoe.h~aoe-bring-driver-version-number-to-47 drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-bring-driver-version-number-to-47
+++ a/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "32"
+#define VERSION "47"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
