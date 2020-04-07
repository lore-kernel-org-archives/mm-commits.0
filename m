From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 164/166] lib/Kconfig.debug: fix a typo
 "capabilitiy" -> "capability"
Date: Mon, 06 Apr 2020 20:12:49 -0700
Message-ID: <20200407031249.KYHDZkN5z%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgDGDMv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:12:51 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hqjagain@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
