From: akpm@linux-foundation.org
Subject: [merged] lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:46 -0700
Message-ID: <201111012112.pA1LCkY5031122@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jjzhang@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: fix help message for DEFAULT_HUNG_TASK_TIMEOUT
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jiaju Zhang <jjzhang@suse.de>
Subject: lib/Kconfig.debug: fix help message for DEFAULT_HUNG_TASK_TIMEOUT

Added missing _secs in the help message of config DEFAULT_HUNG_TASK_TIMEOUT.

Signed-off-by: Jiaju Zhang <jjzhang@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout
+++ a/lib/Kconfig.debug
@@ -248,8 +248,9 @@ config DEFAULT_HUNG_TASK_TIMEOUT
 	  to determine when a task has become non-responsive and should
 	  be considered hung.
 
-	  It can be adjusted at runtime via the kernel.hung_task_timeout
-	  sysctl or by writing a value to /proc/sys/kernel/hung_task_timeout.
+	  It can be adjusted at runtime via the kernel.hung_task_timeout_secs
+	  sysctl or by writing a value to
+	  /proc/sys/kernel/hung_task_timeout_secs.
 
 	  A timeout of 0 disables the check.  The default is two minutes.
 	  Keeping the default should be fine in most cases.
_

Patches currently in -mm which might be from jjzhang@suse.de are

origin.patch

