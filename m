From: akpm@linux-foundation.org
Subject: [folded-merged] mm-consolidate-page-table-accounting-fix.patch
 removed from -mm tree
Date: Wed, 15 Nov 2017 17:02:34 -0800
Message-ID: <5a0ce3aa.arjvZgtskMzon4O2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932219AbdKPBCg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-consolidate-page-table-accounting-fix
has been removed from the -mm tree.  Its filename was
     mm-consolidate-page-table-accounting-fix.patch

This patch was dropped because it was folded into mm-consolidate-page-table-accounting.patch

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
@@ -1669,7 +1669,7 @@ static inline void mm_dec_nr_ptes(struct
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
mm-introduce-wrappers-to-access-mm-nr_ptes.patch
mm-consolidate-page-table-accounting.patch

