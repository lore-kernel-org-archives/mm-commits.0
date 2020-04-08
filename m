From: akpm@linux-foundation.org
Subject: [merged] kmod-fix-a-typo-assuems-assumes.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:02:11 -0700
Message-ID: <20200408020211.rYOXZ6KlC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCCN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hqjagain@gmail.com, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kmod.c: fix a typo "assuems" -> "assumes"
has been removed from the -mm tree.  Its filename was
     kmod-fix-a-typo-assuems-assumes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hqjagain@gmail.com are

mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch
