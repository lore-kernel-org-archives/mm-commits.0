From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 146/166] kernel/kmod.c: fix a typo "assuems" ->
 "assumes"
Date: Mon, 06 Apr 2020 20:11:49 -0700
Message-ID: <20200407031149.3_1P_QFHW%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDL6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:58 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hqjagain@gmail.com, linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Qiujun Huang <hqjagain@gmail.com>
Subject: kernel/kmod.c: fix a typo "assuems" -> "assumes"

There is a typo in comment.  Fix it.  s/assuems/assumes/

Link: http://lkml.kernel.org/r/1585891029-6450-1-git-send-email-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kmod.c~kmod-fix-a-typo-assuems-assumes
+++ a/kernel/kmod.c
@@ -35,7 +35,7 @@
  *		       (u64) THREAD_SIZE * 8UL);
  *
  * If you need less than 50 threads would mean we're dealing with systems
- * smaller than 3200 pages. This assuems you are capable of having ~13M memory,
+ * smaller than 3200 pages. This assumes you are capable of having ~13M memory,
  * and this would only be an be an upper limit, after which the OOM killer
  * would take effect. Systems like these are very unlikely if modules are
  * enabled.
_
