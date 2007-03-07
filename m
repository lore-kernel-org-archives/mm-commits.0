From: akpm@linux-foundation.org
Subject: - remove-stack-hard-limit-on-ia64.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:13 -0800
Message-ID: <200703070422.l274MDvT018972@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47115 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbXCGEWU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwab@suse.de, olaf@aepfle.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Remove stack hard limit on ia64
has been removed from the -mm tree.  Its filename was
     remove-stack-hard-limit-on-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove stack hard limit on ia64
From: <schwab@suse.de>

Un-Breaks pthreads, since Oct 2003.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/resource.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-ia64/resource.h~remove-stack-hard-limit-on-ia64 include/asm-ia64/resource.h
--- a/include/asm-ia64/resource.h~remove-stack-hard-limit-on-ia64
+++ a/include/asm-ia64/resource.h
@@ -2,7 +2,6 @@
 #define _ASM_IA64_RESOURCE_H
 
 #include <asm/ustack.h>
-#define _STK_LIM_MAX	DEFAULT_USER_STACK_SIZE
 #include <asm-generic/resource.h>
 
 #endif /* _ASM_IA64_RESOURCE_H */
_

Patches currently in -mm which might be from schwab@suse.de are

origin.patch
