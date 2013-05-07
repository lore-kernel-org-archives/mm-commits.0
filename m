From: akpm@linux-foundation.org
Subject: [merged] notifier-error-inject-fix-module-names-in-kconfig.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:11 -0700
Message-ID: <20130507175111.7640131C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59710 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:12 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so86433vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: notifier-error-inject: fix module names in Kconfig
has been removed from the -mm tree.  Its filename was
     notifier-error-inject-fix-module-names-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: notifier-error-inject: fix module names in Kconfig

The Kconfig help text for MEMORY_NOTIFIER_ERROR_INJECT and
OF_RECONFIG_NOTIFIER_ERROR_INJECT has mismatched module names.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~notifier-error-inject-fix-module-names-in-kconfig lib/Kconfig.debug
--- a/lib/Kconfig.debug~notifier-error-inject-fix-module-names-in-kconfig
+++ a/lib/Kconfig.debug
@@ -1192,7 +1192,7 @@ config MEMORY_NOTIFIER_ERROR_INJECT
 	  bash: echo: write error: Cannot allocate memory
 
 	  To compile this code as a module, choose M here: the module will
-	  be called pSeries-reconfig-notifier-error-inject.
+	  be called memory-notifier-error-inject.
 
 	  If unsure, say N.
 
@@ -1209,7 +1209,7 @@ config OF_RECONFIG_NOTIFIER_ERROR_INJECT
 	  notified, write the error code to "actions/<notifier event>/error".
 
 	  To compile this code as a module, choose M here: the module will
-	  be called memory-notifier-error-inject.
+	  be called of-reconfig-notifier-error-inject.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch

