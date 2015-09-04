From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
 removed from -mm tree
Date: Fri, 04 Sep 2015 15:35:32 -0700
Message-ID: <55ea1cb4.THk41yOKDcXR6yzh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022AbbIDWfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@kernel.org, catalin.marinas@arm.com, kirill.shutemov@linux.intel.com, sfr@canb.auug.org.au, toshi.kani@hp.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix
has been removed from the -mm tree.  Its filename was
     mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

This patch was dropped because it was folded into mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix

fix arm64 build

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/gup.c~mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix mm/gup.c
--- a/mm/gup.c~mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix
+++ a/mm/gup.c
@@ -12,7 +12,9 @@
 #include <linux/sched.h>
 #include <linux/rwsem.h>
 #include <linux/hugetlb.h>
+
 #include <asm/pgtable.h>
+#include <asm/tlbflush.h>
 
 #include "internal.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch

