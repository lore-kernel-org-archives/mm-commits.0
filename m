From: akpm@linux-foundation.org
Subject: + lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:57:26 -0700
Message-ID: <201109082357.p88NvQdl016145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756326Ab1IHX53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jjzhang@suse.de


The patch titled
     lib/Kconfig.debug: fix help message for DEFAULT_HUNG_TASK_TIMEOUT
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/Kconfig.debug: fix help message for DEFAULT_HUNG_TASK_TIMEOUT
From: Jiaju Zhang <jjzhang@suse.de>

Added missing _secs in the help message of config DEFAULT_HUNG_TASK_TIMEOUT.

Signed-off-by: Jiaju Zhang <jjzhang@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout
+++ a/lib/Kconfig.debug
@@ -249,8 +249,9 @@ config DEFAULT_HUNG_TASK_TIMEOUT
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

lib-kconfigdebug-fix-help-message-for-default_hung_task_timeout.patch

