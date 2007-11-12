From: akpm@linux-foundation.org
Subject: + remove-unnecessary-include-from-include-linux-capabilityh.patch added to -mm tree
Date: Mon, 12 Nov 2007 14:16:14 -0800
Message-ID: <200711122216.lACMGE2G011562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbXKLWQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 17:16:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrew@nagrom.org, kaigai@kaigai.gr.jp, morgan@kernel.org


The patch titled
     Remove unnecessary include from include/linux/capability.h
has been added to the -mm tree.  Its filename is
     remove-unnecessary-include-from-include-linux-capabilityh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

remove-unnecessary-include-from-include-linux-capabilityh.patch
