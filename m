From: akpm@linux-foundation.org
Subject: [merged] aoe-update-internal-version-number-to-49.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:40 -0700
Message-ID: <20121005202140.8E7D91E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56456 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:41 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so237754qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update internal version number to 49
has been removed from the -mm tree.  Its filename was
     aoe-update-internal-version-number-to-49.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update internal version number to 49

The internal version number of the aoe driver appears in a console message
when the driver loads and is usually obtained by the user with the
userland aoe-version tool, part of the aoetools.[1]

Although this patchset includes bugfixes backported from higher-numbered
versions published on the coraid.com website, it is a form of version 49.

1. http://aoetools.sourceforge.net/

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-internal-version-number-to-49 drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-internal-version-number-to-49
+++ a/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "47"
+#define VERSION "49"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

