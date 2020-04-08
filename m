From: akpm@linux-foundation.org
Subject: [merged]
 lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:00:46 -0700
Message-ID: <20200408020046.jqQ9aRQ1f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgDHCAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, gregkh@linuxfoundation.org, keescook@chromium.org, khlebnikov@yandex-team.ru, linux@roeck-us.net, mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org, sashal@kernel.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: lib/test_lockup.c: fix spelling mistake "iteraions" -> "iterations"
has been removed from the -mm tree.  Its filename was
     lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: lib/test_lockup.c: fix spelling mistake "iteraions" -> "iterations"

There is a spelling mistake in a pr_notice message.  Fix it.

Link: http://lkml.kernel.org/r/20200221155145.79522-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
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
