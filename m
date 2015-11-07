From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-unsigned-int-for-page-order-fix.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 16:12:24 -0800
Message-ID: <563d41e8.Mvek+oR6BnRCQvDG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbbKGAMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:12:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-unsigned-int-for-page-order-fix
has been removed from the -mm tree.  Its filename was
     mm-use-unsigned-int-for-page-order-fix.patch

This patch was dropped because it was folded into mm-use-unsigned-int-for-page-order.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm-use-unsigned-int-for-page-order-fix

fix build (type of pageblock_order)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pageblock-flags.h~mm-use-unsigned-int-for-page-order-fix include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-use-unsigned-int-for-page-order-fix
+++ a/include/linux/pageblock-flags.h
@@ -44,7 +44,7 @@ enum pageblock_bits {
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Huge page sizes are variable */
-extern int pageblock_order;
+extern unsigned int pageblock_order;
 
 #else /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-use-unsigned-int-for-page-order.patch

