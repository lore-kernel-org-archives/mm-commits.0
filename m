From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 04/15] kernel/kcov.c: fix typos in
 kcov_remote_start documentation
Date: Thu, 07 May 2020 18:35:49 -0700
Message-ID: <20200508013549.M4PmRWho3%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgEHBfv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 21:35:51 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, linux-mm@kvack.org, maciej.grochowski@pm.me, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
