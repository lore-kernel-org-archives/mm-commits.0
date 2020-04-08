From: akpm@linux-foundation.org
Subject: [merged]
 lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 19:02:38 -0700
Message-ID: <20200408020238.bHBamqVi1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgDHCCk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hqjagain@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: fix a typo "capabilitiy" -> "capability"
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiujun Huang <hqjagain@gmail.com>
Subject: lib/Kconfig.debug: fix a typo "capabilitiy" -> "capability"

s/capabilitiy/capability

Link: http://lkml.kernel.org/r/1585818594-27373-1-git-send-email-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-a-typo-capabilitiy-capability
+++ a/lib/Kconfig.debug
@@ -1655,7 +1655,7 @@ config FAILSLAB
 	  Provide fault-injection capability for kmalloc.
 
 config FAIL_PAGE_ALLOC
-	bool "Fault-injection capabilitiy for alloc_pages()"
+	bool "Fault-injection capability for alloc_pages()"
 	depends on FAULT_INJECTION
 	help
 	  Provide fault-injection capability for alloc_pages().
_

Patches currently in -mm which might be from hqjagain@gmail.com are

mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch
