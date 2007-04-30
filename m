From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-timerfd-core-fix-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:32:00 -0700
Message-ID: <200704302032.l3UKW08i014318@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946790AbXD3UcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     new fds fixes for 2.6.21-rc5.mm4 - timerfd include files diet
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-timerfd-core-fix-fix.patch

This patch was dropped because it was folded into signal-timer-event-fds-v9-timerfd-core.patch

------------------------------------------------------
Subject: new fds fixes for 2.6.21-rc5.mm4 - timerfd include files diet
From: Davide Libenzi <davidel@xmailserver.org>

Removes a few unneeded include files from the timerfd code.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/timerfd.c~signal-timer-event-fds-v9-timerfd-core-fix-fix fs/timerfd.c
--- a/fs/timerfd.c~signal-timer-event-fds-v9-timerfd-core-fix-fix
+++ a/fs/timerfd.c
@@ -10,23 +10,17 @@
 
 #include <linux/file.h>
 #include <linux/poll.h>
-#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/kernel.h>
-#include <linux/signal.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/time.h>
 #include <linux/hrtimer.h>
-#include <linux/jiffies.h>
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
 
-#include <asm/uaccess.h>
-
 struct timerfd_ctx {
 	struct hrtimer tmr;
 	ktime_t tintv;
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-optimizations-and-cleanups.patch
introduce-a-handy-list_first_entry-macro-v2.patch
signal-timer-event-fds-v9-anonymous-inode-source.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-signalfd-wire-up-x86-arches.patch
signal-timer-event-fds-v9-signalfd-compat-code.patch
signal-timer-event-fds-v9-timerfd-core.patch
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
