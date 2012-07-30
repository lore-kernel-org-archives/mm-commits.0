From: akpm@linux-foundation.org
Subject: [folded] memory-memory-notifier-error-injection-module-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:27:44 -0700
Message-ID: <20120730212745.0E9DB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:47809 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3V1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:27:46 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4010568obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:27:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: notifier error injection: fix copy-and-paste error in Kconfig help
has been removed from the -mm tree.  Its filename was
     memory-memory-notifier-error-injection-module-fix.patch

This patch was dropped because it was folded into memory-memory-notifier-error-injection-module.patch

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

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
string-introduce-memweight.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
fork-fix-error-handling-in-dup_task.patch
fault-injection-notifier-error-injection.patch
cpu-rewrite-cpu-notifier-error-inject-module.patch
pm-pm-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module.patch
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch

