From: akpm@linux-foundation.org
Subject: + kmemleak-fix-reference-to-documentation.patch added to -mm tree
Date: Tue, 18 Oct 2016 13:57:21 -0700
Message-ID: <58068cb1.MQFdrBSPmSiggLmr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56517 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbcJRU5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 16:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.platschek@opentech.at, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: fix reference to Documentation
has been added to the -mm tree.  Its filename is
     kmemleak-fix-reference-to-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-fix-reference-to-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-fix-reference-to-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Platschek <andreas.platschek@opentech.at>
Subject: kmemleak: fix reference to Documentation

Documentation/kmemleak.txt was moved to Documentation/dev-tools/kmemleak.rst,
this fixes the reference to the new location.

Link: http://lkml.kernel.org/r/1476544946-18804-1-git-send-email-andreas.platschek@opentech.at
Signed-off-by: Andreas Platschek <andreas.platschek@opentech.at>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~kmemleak-fix-reference-to-documentation mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-fix-reference-to-documentation
+++ a/mm/kmemleak.c
@@ -19,7 +19,7 @@
  *
  *
  * For more information on the algorithm and kmemleak usage, please see
- * Documentation/kmemleak.txt.
+ * Documentation/dev-tools/kmemleak.rst.
  *
  * Notes on locking
  * ----------------
_

Patches currently in -mm which might be from andreas.platschek@opentech.at are

kmemleak-fix-reference-to-documentation.patch
kconfig-lib-kconfigdebug-fix-references-to-documenation.patch
kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation.patch

