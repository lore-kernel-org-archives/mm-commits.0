From: akpm@linux-foundation.org
Subject: [merged] include-linux-resourceh-needs-typesh.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:29:59 -0800
Message-ID: <201011161933.oAGJXBeO003081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757422Ab0KPTdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/resource.h needs types.h
has been removed from the -mm tree.  Its filename was
     include-linux-resourceh-needs-typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/resource.h needs types.h
From: Jean Delvare <khali@linux-fr.org>

Fix the following warning:
usr/include/linux/resource.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/resource.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/resource.h~include-linux-resourceh-needs-typesh include/linux/resource.h
--- a/include/linux/resource.h~include-linux-resourceh-needs-typesh
+++ a/include/linux/resource.h
@@ -2,6 +2,7 @@
 #define _LINUX_RESOURCE_H
 
 #include <linux/time.h>
+#include <linux/types.h>
 
 /*
  * Resource control/accounting header file for linux
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch

