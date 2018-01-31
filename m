From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-store-compound_dtor-compound_order-as-bytes-fix.patch removed from -mm
 tree
Date: Wed, 31 Jan 2018 15:58:31 -0800
Message-ID: <5a725827.elkP8f18ehFCPS+A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57450 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbeAaX6d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, cl@linux.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-store-compound_dtor-compound_order-as-bytes-fix
has been removed from the -mm tree.  Its filename was
     mm-store-compound_dtor-compound_order-as-bytes-fix.patch

This patch was dropped because it was folded into mm-store-compound_dtor-compound_order-as-bytes.patch

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: mm-store-compound_dtor-compound_order-as-bytes-fix

add comment

Link: http://lkml.kernel.org/r/20171221000144.GB2980@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mm_types.h~mm-store-compound_dtor-compound_order-as-bytes-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-store-compound_dtor-compound_order-as-bytes-fix
+++ a/include/linux/mm_types.h
@@ -138,6 +138,7 @@ struct page {
 			/* First tail page only */
 			unsigned char compound_dtor;
 			unsigned char compound_order;
+			/* two/six bytes available here */
 		};
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

mm-align-struct-page-more-aesthetically.patch
mm-de-indent-struct-page.patch
mm-remove-misleading-alignment-claims.patch
mm-improve-comment-on-page-mapping.patch
mm-introduce-_slub_counter_t.patch
mm-store-compound_dtor-compound_order-as-bytes.patch
mm-document-how-to-use-struct-page.patch
mm-remove-reference-to-pg_buddy.patch

