From: akpm@linux-foundation.org
Subject: [merged] mm-gupc-corrected-document-reference-path.patch
 removed from -mm tree
Date: Fri, 01 May 2020 11:18:42 -0700
Message-ID: <20200501181842.p58yA3Heq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729138AbgEASSo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 May 2020 14:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ira.weiny@intel.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: correct document reference path
has been removed from the -mm tree.  Its filename was
     mm-gupc-corrected-document-reference-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: mm/gup.c: correct document reference path

Document path Documentation/vm/pin_user_pages.rst is not a correct
reference and it should be Documentation/core-api/pin_user_pages.rst.

Link: http://lkml.kernel.org/r/1588273314-3790-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/gup.c~mm-gupc-corrected-document-reference-path
+++ a/mm/gup.c
@@ -2864,10 +2864,10 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
  * the arguments here are identical.
  *
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
- * see Documentation/vm/pin_user_pages.rst for further details.
+ * see Documentation/core-api/pin_user_pages.rst for further details.
  *
- * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
- * is NOT intended for Case 2 (RDMA: long-term pins).
+ * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst.
+ * It is NOT intended for Case 2 (RDMA: long-term pins).
  */
 int pin_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages)
@@ -2904,10 +2904,10 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
  * the arguments here are identical.
  *
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
- * see Documentation/vm/pin_user_pages.rst for details.
+ * see Documentation/core-api/pin_user_pages.rst for details.
  *
- * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
- * is NOT intended for Case 2 (RDMA: long-term pins).
+ * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst.
+ * It is NOT intended for Case 2 (RDMA: long-term pins).
  */
 long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
@@ -2940,10 +2940,10 @@ EXPORT_SYMBOL(pin_user_pages_remote);
  * FOLL_PIN is set.
  *
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
- * see Documentation/vm/pin_user_pages.rst for details.
+ * see Documentation/core-api/pin_user_pages.rst for details.
  *
- * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
- * is NOT intended for Case 2 (RDMA: long-term pins).
+ * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst.
+ * It is NOT intended for Case 2 (RDMA: long-term pins).
  */
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages,
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are

mm-gupc-updating-the-documentation.patch
