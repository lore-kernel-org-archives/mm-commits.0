From: akpm@linux-foundation.org
Subject: +
 kernel-kcovc-fix-typos-in-kcov_remote_start-documentation.patch added to
 -mm tree
Date: Mon, 20 Apr 2020 15:07:33 -0700
Message-ID: <20200420220733.OO0RnJuMN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgDTWHe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, maciej.grochowski@pm.me, maciek.grochowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kcov.c: fix typos in kcov_remote_start documentation
has been added to the -mm tree.  Its filename is
     kernel-kcovc-fix-typos-in-kcov_remote_start-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kcovc-fix-typos-in-kcov_remote_start-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kcovc-fix-typos-in-kcov_remote_start-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maciej Grochowski <maciek.grochowski@gmail.com>
Subject: kernel/kcov.c: fix typos in kcov_remote_start documentation


Link: http://lkml.kernel.org/r/20200420030259.31674-1-maciek.grochowski@gmail.com
Signed-off-by: Maciej Grochowski <maciej.grochowski@pm.me>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kcov.c~kernel-kcovc-fix-typos-in-kcov_remote_start-documentation
+++ a/kernel/kcov.c
@@ -752,8 +752,8 @@ static const struct file_operations kcov
  * kcov_remote_handle() with KCOV_SUBSYSTEM_COMMON as the subsystem id and an
  * arbitrary 4-byte non-zero number as the instance id). This common handle
  * then gets saved into the task_struct of the process that issued the
- * KCOV_REMOTE_ENABLE ioctl. When this proccess issues system calls that spawn
- * kernel threads, the common handle must be retrived via kcov_common_handle()
+ * KCOV_REMOTE_ENABLE ioctl. When this process issues system calls that spawn
+ * kernel threads, the common handle must be retrieved via kcov_common_handle()
  * and passed to the spawned threads via custom annotations. Those kernel
  * threads must in turn be annotated with kcov_remote_start(common_handle) and
  * kcov_remote_stop(). All of the threads that are spawned by the same process
_

Patches currently in -mm which might be from maciek.grochowski@gmail.com are

kernel-kcovc-fix-typos-in-kcov_remote_start-documentation.patch
