From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch added to -mm tree
Date: Fri, 03 Apr 2020 17:21:28 -0700
Message-ID: <20200404002128.nO2eehD6n%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgDDAV3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 20:21:29 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hqjagain@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: fix a typo "capabilitiy" -> "capability"
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1660,7 +1660,7 @@ config FAILSLAB
 	  Provide fault-injection capability for kmalloc.
 
 config FAIL_PAGE_ALLOC
-	bool "Fault-injection capabilitiy for alloc_pages()"
+	bool "Fault-injection capability for alloc_pages()"
 	depends on FAULT_INJECTION
 	help
 	  Provide fault-injection capability for alloc_pages().
_

Patches currently in -mm which might be from hqjagain@gmail.com are

kmod-fix-a-typo-assuems-assumes.patch
lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch
