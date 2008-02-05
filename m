From: akpm@linux-foundation.org
Subject: - remove-unnecessary-include-from-include-linux-capabilityh.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:02 -0800
Message-ID: <200802052232.m15MWhCe012353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761009AbYBEWmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew@nagrom.org, kaigai@kaigai.gr.jp, morgan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Remove unnecessary include from include/linux/capability.h
has been removed from the -mm tree.  Its filename was
     remove-unnecessary-include-from-include-linux-capabilityh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove unnecessary include from include/linux/capability.h
From: Andrew Morgan <andrew@nagrom.org>

KaiGai Kohei observed that this line in the linux header is not needed.

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/capability.h~remove-unnecessary-include-from-include-linux-capabilityh include/linux/capability.h
--- a/include/linux/capability.h~remove-unnecessary-include-from-include-linux-capabilityh
+++ a/include/linux/capability.h
@@ -14,7 +14,6 @@
 #define _LINUX_CAPABILITY_H
 
 #include <linux/types.h>
-#include <linux/compiler.h>
 
 struct task_struct;
 
_

Patches currently in -mm which might be from andrew@nagrom.org are

origin.patch
