From: akpm@linux-foundation.org
Subject: + signal-timer-event-fds-v9-anonymous-inode-source-fix.patch added to -mm tree
Date: Tue, 03 Apr 2007 18:12:23 -0700
Message-ID: <200704040112.l341CNFp008546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbXDDBMY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 21:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org


The patch titled
     new fds fixes for 2.6.21-rc5.mm4 - fix a spelling error
has been added to the -mm tree.  Its filename is
     signal-timer-event-fds-v9-anonymous-inode-source-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: new fds fixes for 2.6.21-rc5.mm4 - fix a spelling error
From: Davide Libenzi <davidel@xmailserver.org>

Fixes a spelling error inside init/Kconfig.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~signal-timer-event-fds-v9-anonymous-inode-source-fix init/Kconfig
--- a/init/Kconfig~signal-timer-event-fds-v9-anonymous-inode-source-fix
+++ a/init/Kconfig
@@ -479,7 +479,7 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config ANON_INODES
-	bool "Enable anynimous inode source" if EMBEDDED
+	bool "Enable anonymous inode source" if EMBEDDED
 	default y
 	help
 	  Anonymous inode source for pseudo-files like epoll, signalfd,
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
epoll-optimizations-and-cleanups.patch
epoll-optimizations-and-cleanups-tidy.patch
signal-timer-event-fds-v9-anonymous-inode-source.patch
signal-timer-event-fds-v9-anonymous-inode-source-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-signalfd-wire-up-i386-arch.patch
signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch.patch
signal-timer-event-fds-v9-signalfd-compat-code.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-timerfd-wire-up-i386-arch.patch
signal-timer-event-fds-v9-timerfd-wire-up-x86_64-arch.patch
signal-timer-event-fds-v9-timerfd-compat-code.patch
signal-timer-event-fds-v9-eventfd-core.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
signal-timer-event-fds-v9-eventfd-wire-up-i386-arch.patch
signal-timer-event-fds-v9-eventfd-wire-up-x86_64-arch.patch
signal-timer-event-fds-v9-kaio-eventfd-support-example.patch
epoll-use-anonymous-inodes.patch
new-fds-fixes-for-2621-rc5mm4-signalfd-include-files-diet.patch
new-fds-fixes-for-2621-rc5mm4-timerfd-include-files-diet.patch
new-fds-fixes-for-2621-rc5mm4-eventfd-include-files-diet.patch
