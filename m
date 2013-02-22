From: akpm@linux-foundation.org
Subject: + coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix.patch added to -mm tree
Date: Fri, 22 Feb 2013 14:07:47 -0800
Message-ID: <20130222220747.9FABC5A420F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55733 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3BVWHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 17:07:48 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so112837yhz.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 14:07:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, msb@chromium.org


The patch titled
     Subject: kernel/exit.c: remove duplicated include
has been added to the -mm tree.  Its filename is
     coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: kernel/exit.c: remove duplicated include

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/exit.c~coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix kernel/exit.c
--- a/kernel/exit.c~coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix
+++ a/kernel/exit.c
@@ -32,7 +32,6 @@
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
-#include <linux/freezer.h>
 #include <linux/cgroup.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix.patch
memstick-move-the-dereference-below-the-null-test.patch

