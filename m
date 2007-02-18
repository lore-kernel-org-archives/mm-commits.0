From: akpm@linux-foundation.org
Subject: - atl1-remove-unused-define.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:00 -0800
Message-ID: <200702180215.l1I2F0vQ008325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55649 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993098AbXBRCPJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csnook@redhat.com, jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     atl1: remove unused define
has been removed from the -mm tree.  Its filename was
     atl1-remove-unused-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1: remove unused define
From: Chris Snook <csnook@redhat.com>

Remove unused define from atl1_main.c.

Signed-off-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-remove-unused-define drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-remove-unused-define
+++ a/drivers/net/atl1/atl1_main.c
@@ -82,7 +82,6 @@
 
 #include "atl1.h"
 
-#define RUN_REALTIME 0
 #define DRIVER_VERSION "2.0.6"
 
 char atl1_driver_name[] = "atl1";
_

Patches currently in -mm which might be from csnook@redhat.com are

git-netdev-all.patch
