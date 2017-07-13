From: akpm@linux-foundation.org
Subject: [merged] watchdog-remove-unused-declaration.patch removed
 from -mm tree
Date: Thu, 13 Jul 2017 13:41:57 -0700
Message-ID: <20170713204157.ZEycT8ZpW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org


The patch titled
     Subject: kernel/watchdog: remove unused declaration
has been removed from the -mm tree.  Its filename was
     watchdog-remove-unused-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/watchdog: remove unused declaration

Patch series "Improve watchdog config for arch watchdogs", v4.

A series to make the hardlockup watchdog more easily replaceable by arch
code.  The last patch provides some justification for why we want to do
this (existing sparc watchdog is another that could benefit).


This patch (of 5):

Remove unused declaration.

Link: http://lkml.kernel.org/r/20170616065715.18390-2-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Babu Moger <babu.moger@oracle.com>
Tested-by: Babu Moger <babu.moger@oracle.com>	[sparc]
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/nmi.h~watchdog-remove-unused-declaration include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-remove-unused-declaration
+++ a/include/linux/nmi.h
@@ -12,9 +12,6 @@ extern void touch_softlockup_watchdog_sc
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-				  void __user *buffer,
-				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern unsigned int  hardlockup_panic;
 void lockup_detector_init(void);
_

Patches currently in -mm which might be from npiggin@gmail.com are


