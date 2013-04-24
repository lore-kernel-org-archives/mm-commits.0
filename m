From: akpm@linux-foundation.org
Subject: + notifier-error-inject-fix-module-names-in-kconfig.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:48:52 -0700
Message-ID: <20130424224852.6B8F331C19E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:52767 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab3DXWsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:48:54 -0400
Received: by mail-ye0-f202.google.com with SMTP id l8so254891yen.5
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:48:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     Subject: notifier-error-inject: fix module names in Kconfig
has been added to the -mm tree.  Its filename is
     notifier-error-inject-fix-module-names-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

