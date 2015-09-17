From: akpm@linux-foundation.org
Subject: + mm-use-unsigned-int-for-page-order-fix.patch added to -mm tree
Date: Thu, 17 Sep 2015 12:28:30 -0700
Message-ID: <55fb145e.K+jzDZFBbWjkKEEr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbbIQT2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 15:28:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-unsigned-int-for-page-order-fix
has been added to the -mm tree.  Its filename is
     mm-use-unsigned-int-for-page-order-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-unsigned-int-for-page-order-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-unsigned-int-for-page-order-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-use-unsigned-int-for-page-order-fix.patch

