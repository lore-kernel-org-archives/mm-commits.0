From: akpm@linux-foundation.org
Subject: + hugetlb-update-hugetlbpagetxt.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:26:49 -0700
Message-ID: <20120815232649.9E000100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:36225 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2HOX0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:26:50 -0400
Received: by obbwc20 with SMTP id wc20so1538155obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:26:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sanweidaying@gmail.com, dyoung@redhat.com


The patch titled
     Subject: hugetlb: update hugetlbpage.txt
has been added to the -mm tree.  Its filename is
     hugetlb-update-hugetlbpagetxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hugetlb-update-hugetlbpagetxt.patch

