From: akpm@linux-foundation.org
Subject: + watchdog-remove-unnecessary-head-files.patch added to -mm tree
Date: Wed, 13 Aug 2014 15:28:45 -0700
Message-ID: <53ebe69d.8q5vla/8E+7wcMJD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:63394 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaHMW2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 18:28:46 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so55949yha.0
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 15:28:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaiw.fnst@cn.fujitsu.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: remove unnecessary header files
has been added to the -mm tree.  Its filename is
     watchdog-remove-unnecessary-head-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-remove-unnecessary-head-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-remove-unnecessary-head-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: kernel/watchdog.c: remove unnecessary header files

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN kernel/watchdog.c~watchdog-remove-unnecessary-head-files kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-remove-unnecessary-head-files
+++ a/kernel/watchdog.c
@@ -15,11 +15,6 @@
 #include <linux/cpu.h>
 #include <linux/nmi.h>
 #include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/freezer.h>
-#include <linux/kthread.h>
-#include <linux/lockdep.h>
-#include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/smpboot.h>
_

Patches currently in -mm which might be from chaiw.fnst@cn.fujitsu.com are

watchdog-remove-unnecessary-head-files.patch
softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch

