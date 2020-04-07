From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 109/166] lib/test_lockup.c: fix spelling mistake
 "iteraions" -> "iterations"
Date: Mon, 06 Apr 2020 20:09:50 -0700
Message-ID: <20200407030950.qo0fhRDd-%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgDGDJw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:52 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, gregkh@linuxfoundation.org, keescook@chromium.org, khlebnikov@yandex-team.ru, linux-mm@kvack.org, linux@roeck-us.net, mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org, sashal@kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

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
