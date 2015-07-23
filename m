From: akpm@linux-foundation.org
Subject: + fs-daxc-fix-typo-in-endif-comment.patch added to -mm tree
Date: Thu, 23 Jul 2015 12:58:21 -0700
Message-ID: <55b1475d.F6SCMbfzwHnzWC5I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbbGWT6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 15:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dax.c: fix typo in #endif comment
has been added to the -mm tree.  Its filename is
     fs-daxc-fix-typo-in-endif-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-daxc-fix-typo-in-endif-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-daxc-fix-typo-in-endif-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: fs/dax.c: fix typo in #endif comment

Fix typo s/CONFIG_TRANSPARENT_HUGEPAGES/CONFIG_TRANSPARENT_HUGEPAGE/ in
#endif comment introduced by commit 2b26a9206d6a ("dax: add huge page
fault support").

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~fs-daxc-fix-typo-in-endif-comment fs/dax.c
--- a/fs/dax.c~fs-daxc-fix-typo-in-endif-comment
+++ a/fs/dax.c
@@ -634,7 +634,7 @@ int dax_pmd_fault(struct vm_area_struct
 	return result;
 }
 EXPORT_SYMBOL_GPL(dax_pmd_fault);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGES */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /**
  * dax_pfn_mkwrite - handle first write to DAX page
_

Patches currently in -mm which might be from valentinrothberg@gmail.com are

fs-daxc-fix-typo-in-endif-comment.patch
linux-next.patch

