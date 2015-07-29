From: akpm@linux-foundation.org
Subject: +
 watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2.patch added to -mm tree
Date: Wed, 29 Jul 2015 11:00:22 -0700
Message-ID: <55b914b6.mF+7x0/mOYM53nay%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbbG2SAY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:00:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, dzickus@redhat.com, eranian@google.com, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2
has been added to the -mm tree.  Its filename is
     watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

iommu-common-do-not-use-64-bit-constant-0xffffffffffffffffl-for-computing-align_mask.patch
watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih.patch
watchdog-move-nmi-function-header-declarations-from-watchdogh-to-nmih-v2.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
linux-next.patch

