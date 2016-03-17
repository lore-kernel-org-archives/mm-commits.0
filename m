From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch removed from -mm tree
Date: Thu, 17 Mar 2016 13:58:06 -0700
Message-ID: <56eb1a5e.G/9P+0FvniBL3qR0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbcCQU6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ref: fix build failure for xtensa
has been removed from the -mm tree.  Its filename was
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

This patch was dropped because it was folded into mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_ref: fix build failure for xtensa

This patch includes struct page definition to fix build failure on xtensa.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_page_ref.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/debug_page_ref.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3 mm/debug_page_ref.c
--- a/mm/debug_page_ref.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3
+++ a/mm/debug_page_ref.c
@@ -1,3 +1,4 @@
+#include <linux/mm_types.h>
 #include <linux/tracepoint.h>
 
 #define CREATE_TRACE_POINTS
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

