From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-signalfd-core-fix-fix-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:30:50 -0700
Message-ID: <200704302030.l3UKUoYo014297@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946804AbXD3Uaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     new fds fixes for 2.6.21-rc5.mm4 - signalfd include files diet
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-signalfd-core-fix-fix-fix.patch

This patch was dropped because it was folded into signal-timer-event-fds-v9-signalfd-core.patch

------------------------------------------------------
Subject: new fds fixes for 2.6.21-rc5.mm4 - signalfd include files diet
From: Davide Libenzi <davidel@xmailserver.org>

Removes a few unneeded include files from the signalfd code.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/signalfd.c~signal-timer-event-fds-v9-signalfd-core-fix-fix-fix fs/signalfd.c
--- a/fs/signalfd.c~signal-timer-event-fds-v9-signalfd-core-fix-fix-fix
+++ a/fs/signalfd.c
@@ -15,19 +15,15 @@
 
 #include <linux/file.h>
 #include <linux/poll.h>
-#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/list.h>
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 
-#include <asm/uaccess.h>
-
 struct signalfd_ctx {
 	struct list_head lnk;
 	wait_queue_head_t wqh;
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-optimizations-and-cleanups.patch
introduce-a-handy-list_first_entry-macro-v2.patch
signal-timer-event-fds-v9-anonymous-inode-source.patch
signal-timer-event-fds-v9-signalfd-core.patch
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
