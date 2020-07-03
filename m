From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Thu, 02 Jul 2020 22:16:11 -0700
Message-ID: <20200703051611.8agcK4Evj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgGCFQL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 01:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/tree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/rcu/tree.c~linux-next-rejects
+++ a/kernel/rcu/tree.c
@@ -45,6 +45,8 @@
 #include <linux/delay.h>
 #include <linux/random.h>
 #include <linux/trace_events.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/suspend.h>
 #include <linux/ftrace.h>
 #include <linux/tick.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch
