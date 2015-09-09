From: akpm@linux-foundation.org
Subject: [merged] fs-daxc-fix-typo-in-endif-comment.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:13 -0700
Message-ID: <55f08bd1.DC+o1B0Qm9eaZQp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIITnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dax.c: fix typo in #endif comment
has been removed from the -mm tree.  Its filename was
     fs-daxc-fix-typo-in-endif-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -644,7 +644,7 @@ int dax_pmd_fault(struct vm_area_struct
 	return result;
 }
 EXPORT_SYMBOL_GPL(dax_pmd_fault);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGES */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /**
  * dax_pfn_mkwrite - handle first write to DAX page
_

Patches currently in -mm which might be from valentinrothberg@gmail.com are


