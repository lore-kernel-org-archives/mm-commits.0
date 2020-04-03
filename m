From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmod-fix-a-typo-assuems-assumes.patch added to -mm tree
Date: Fri, 03 Apr 2020 16:48:20 -0700
Message-ID: <20200403234820.-iDGZX7pd%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgDCXsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 19:48:21 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hqjagain@gmail.com, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kmod.c: fix a typo "assuems" -> "assumes"
has been added to the -mm tree.  Its filename is
     kmod-fix-a-typo-assuems-assumes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-fix-a-typo-assuems-assumes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-fix-a-typo-assuems-assumes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kmod-fix-a-typo-assuems-assumes.patch
