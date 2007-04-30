From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-anonymous-inode-source-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:30:24 -0700
Message-ID: <200704302030.l3UKUOAe014277@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946779AbXD3Ua0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     new fds fixes for 2.6.21-rc5.mm4 - fix a spelling error
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-anonymous-inode-source-fix.patch

This patch was dropped because it was folded into signal-timer-event-fds-v9-anonymous-inode-source.patch

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
@@ -483,7 +483,7 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config ANON_INODES
-	bool "Enable anynimous inode source" if EMBEDDED
+	bool "Enable anonymous inode source" if EMBEDDED
 	default y
 	help
 	  Anonymous inode source for pseudo-files like epoll, signalfd,
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-optimizations-and-cleanups.patch
introduce-a-handy-list_first_entry-macro-v2.patch
signal-timer-event-fds-v9-anonymous-inode-source.patch
signal-timer-event-fds-v9-anonymous-inode-source-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix-fix.patch
signal-timer-event-signalfd-wire-up-x86-arches.patch
signal-timer-event-fds-v9-signalfd-compat-code.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix-fix.patch
signal-timer-event-timerfd-wire-up-x86-arches.patch
signal-timer-event-fds-v9-timerfd-compat-code.patch
signal-timer-event-fds-v9-eventfd-core.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix-fix.patch
signal-timer-event-eventfd-wire-up-x86-arches.patch
signal-timer-event-fds-v9-kaio-eventfd-support-example.patch
epoll-use-anonymous-inodes.patch
epoll-cleanups-epoll-no-module.patch
epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code.patch
