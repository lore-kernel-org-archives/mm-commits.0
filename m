From: akpm@linux-foundation.org
Subject: + remove-stack-hard-limit-on-ia64.patch added to -mm tree
Date: Fri, 16 Feb 2007 14:48:50 -0800
Message-ID: <200702162248.l1GMmoOZ011998@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbXBPWs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 17:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwab@suse.de, olaf@aepfle.de, tony.luck@intel.com


The patch titled
     Remove stack hard limit on ia64
has been added to the -mm tree.  Its filename is
     remove-stack-hard-limit-on-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove stack hard limit on ia64
From: <schwab@suse.de>

Un-Breaks pthreads, since Oct 2003.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/resource.h |    1 -
 1 files changed, 1 deletion(-)

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

remove-stack-hard-limit-on-ia64.patch
