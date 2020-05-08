From: akpm@linux-foundation.org
Subject: [merged]
 kernel-kcovc-fix-typos-in-kcov_remote_start-documentation.patch removed
 from -mm tree
Date: Fri, 08 May 2020 15:32:27 -0700
Message-ID: <20200508223227.97zifpobC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbgEHWc3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 18:32:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, maciej.grochowski@pm.me, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kcov.c: fix typos in kcov_remote_start documentation
has been removed from the -mm tree.  Its filename was
     kernel-kcovc-fix-typos-in-kcov_remote_start-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maciej Grochowski <maciej.grochowski@pm.me>
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
@@ -740,8 +740,8 @@ static const struct file_operations kcov
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

Patches currently in -mm which might be from maciej.grochowski@pm.me are
