From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2.patch removed from -mm tree
Date: Fri, 04 Sep 2015 15:26:07 -0700
Message-ID: <55ea1a7f.VzfN8BcIQBmovXbx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760639AbbIDW0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, dzickus@redhat.com, eranian@google.com, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2
has been removed from the -mm tree.  Its filename was
     watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2.patch

This patch was dropped because it was folded into watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih.patch

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2

v2: Remove duplicate dummy functions from kernel/watchdog.c.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/watchdog.c~watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2 kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2
+++ a/kernel/watchdog.c
@@ -651,8 +651,6 @@ unlock:
 #else
 static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
 static void watchdog_nmi_disable(unsigned int cpu) { return; }
-void watchdog_nmi_enable_all(void) {}
-void watchdog_nmi_disable_all(void) {}
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 static struct smp_hotplug_thread watchdog_threads = {
_

Patches currently in -mm which might be from linux@roeck-us.net are

watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih.patch

