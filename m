From: akpm@linux-foundation.org
Subject: [merged] hugetlb-update-hugetlbpagetxt.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:23 -0700
Message-ID: <20120824184124.0E3E9200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53434 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab2HXSl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:26 -0400
Received: by wibhr14 with SMTP id hr14so53119wib.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanweidaying@gmail.com, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: update hugetlbpage.txt
has been removed from the -mm tree.  Its filename was
     hugetlb-update-hugetlbpagetxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhouping Liu <sanweidaying@gmail.com>
Subject: hugetlb: update hugetlbpage.txt

Commit f0f57b2b1 ("mm: move hugepage test examples to
tools/testing/selftests/vm") moved map_hugetlb.c, hugepage-shm.c and
hugepage-mmap.c tests into tools/testing/selftests/vm/ directory, but it
didn't update hugetlbpage.txt

Signed-off-by: Zhouping Liu <sanweidaying@gmail.com>
Acked-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~hugetlb-update-hugetlbpagetxt Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlb-update-hugetlbpagetxt
+++ a/Documentation/vm/hugetlbpage.txt
@@ -299,11 +299,17 @@ map_hugetlb.c.
 *******************************************************************
 
 /*
- * hugepage-shm:  see Documentation/vm/hugepage-shm.c
+ * map_hugetlb: see tools/testing/selftests/vm/map_hugetlb.c
  */
 
 *******************************************************************
 
 /*
- * hugepage-mmap:  see Documentation/vm/hugepage-mmap.c
+ * hugepage-shm:  see tools/testing/selftests/vm/hugepage-shm.c
+ */
+
+*******************************************************************
+
+/*
+ * hugepage-mmap:  see tools/testing/selftests/vm/hugepage-mmap.c
  */
_

Patches currently in -mm which might be from sanweidaying@gmail.com are

origin.patch

