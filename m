From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch removed from -mm
 tree
Date: Thu, 17 Mar 2016 13:50:11 -0700
Message-ID: <56eb1883.Ll7SLR/QC8ZEHUYi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936862AbcCQUuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, borntraeger@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-query-dynamic-debug_pagealloc-setting-v2
has been removed from the -mm tree.  Its filename was
     mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch

This patch was dropped because it was folded into mm-slub-query-dynamic-debug_pagealloc-setting.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-slub-query-dynamic-debug_pagealloc-setting-v2

v2: clean up code, per Christian.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slub.c~mm-slub-query-dynamic-debug_pagealloc-setting-v2 mm/slub.c
--- a/mm/slub.c~mm-slub-query-dynamic-debug_pagealloc-setting-v2
+++ a/mm/slub.c
@@ -256,6 +256,7 @@ static inline void *get_freepointer_safe
 
 	if (!debug_pagealloc_enabled())
 		return get_freepointer(s, object);
+
 	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
 	return p;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

