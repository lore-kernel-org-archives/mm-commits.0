From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch added to
 -mm tree
Date: Sun, 23 Feb 2020 20:10:53 -0800
Message-ID: <20200224041053.-f83nOB9-%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgBXEKy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 23:10:54 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_lockup.c: fix spelling mistake "iteraions" -> "iterations"
has been added to the -mm tree.  Its filename is
     lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: lib/test_lockup.c: fix spelling mistake "iteraions" -> "iterations"

There is a spelling mistake in a pr_notice message.  Fix it.

Link: http://lkml.kernel.org/r/20200221155145.79522-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_lockup.c~lib-test_lockup-fix-spelling-mistake-iteraions-iterations
+++ a/lib/test_lockup.c
@@ -490,7 +490,7 @@ static int __init test_lockup_init(void)
 		return -EINVAL;
 	}
 
-	pr_notice("START pid=%d time=%u +%u ns cooldown=%u +%u ns iteraions=%u state=%s %s%s%s%s%s%s%s%s%s%s%s\n",
+	pr_notice("START pid=%d time=%u +%u ns cooldown=%u +%u ns iterations=%u state=%s %s%s%s%s%s%s%s%s%s%s%s\n",
 		  main_task->pid, time_secs, time_nsecs,
 		  cooldown_secs, cooldown_nsecs, iterations, state,
 		  all_cpus ? "all_cpus " : "",
_

Patches currently in -mm which might be from colin.king@canonical.com are

lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch
