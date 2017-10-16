From: akpm@linux-foundation.org
Subject: + mm-consolidate-page-table-accounting-fix.patch added to -mm
 tree
Date: Mon, 16 Oct 2017 15:39:01 -0700
Message-ID: <59e53505.EVrzTqr1bY3Ix6Em%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753352AbdJPWjC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-consolidate-page-table-accounting-fix
has been added to the -mm tree.  Its filename is
     mm-consolidate-page-table-accounting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-page-table-accounting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-page-table-accounting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm-consolidate-page-table-accounting-fix

fix build

Link: http://lkml.kernel.org/r/20171016150113.ikfxy3e7zzfvsr4w@black.fi.intel.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-consolidate-page-table-accounting-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-consolidate-page-table-accounting-fix
+++ a/include/linux/mm.h
@@ -1668,7 +1668,7 @@ static inline void mm_dec_nr_ptes(struct
 #else
 
 static inline void mm_pgtables_bytes_init(struct mm_struct *mm) {}
-static inline unsigned long mm_pgtables_bytes(struct mm_struct *mm)
+static inline unsigned long mm_pgtables_bytes(const struct mm_struct *mm)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-account-pud-page-tables.patch
mm-account-pud-page-tables-fix.patch
mm-introduce-wrappers-to-access-mm-nr_ptes.patch
mm-consolidate-page-table-accounting.patch
mm-consolidate-page-table-accounting-fix.patch
mm-add-infrastructure-for-get_user_pages_fast-benchmarking.patch

