From: akpm@linux-foundation.org
Subject: + memory-memory-notifier-error-injection-module-fix.patch added to -mm tree
Date: Mon, 09 Jul 2012 13:56:47 -0700
Message-ID: <20120709205647.A03A41E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48318 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2GIU4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 16:56:48 -0400
Received: by ggeh3 with SMTP id h3so1239614gge.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 13:56:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Subject: notifier error injection: fix copy-and-paste error in Kconfig help
has been added to the -mm tree.  Its filename is
     memory-memory-notifier-error-injection-module-fix.patch

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
Subject: notifier error injection: fix copy-and-paste error in Kconfig help

powerpc-pseries-reconfig-notifier-error-injection-module.patch
in -mm tree has a copy-and-paste error in Kconfig help.

The module name should be pSeries-reconfig-notifier-error-inject.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~memory-memory-notifier-error-injection-module-fix lib/Kconfig.debug
--- a/lib/Kconfig.debug~memory-memory-notifier-error-injection-module-fix
+++ a/lib/Kconfig.debug
@@ -1162,7 +1162,7 @@ config MEMORY_NOTIFIER_ERROR_INJECT
 	  bash: echo: write error: Cannot allocate memory
 
 	  To compile this code as a module, choose M here: the module will
-	  be called memory-notifier-error-inject.
+	  be called pSeries-reconfig-notifier-error-inject.
 
 	  If unsure, say N.
 
_
Subject: Subject: notifier error injection: fix copy-and-paste error in Kconfig help

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
string-introduce-memweight.patch
string-introduce-memweight-fix.patch
string-introduce-memweight-fix-build-error-caused-by-memweight-introduction.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch
fault-injection-notifier-error-injection.patch
cpu-rewrite-cpu-notifier-error-inject-module.patch
pm-pm-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module-fix.patch
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch

