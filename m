From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 13:49:00 -0700
Message-ID: <56eb183c.PK506snD4WgUmVPZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbcCQUtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix
has been removed from the -mm tree.  Its filename was
     proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch

This patch was dropped because it was folded into proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix

update comment, per Naoya

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/page.c~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix fs/proc/page.c
--- a/fs/proc/page.c~proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix
+++ a/fs/proc/page.c
@@ -103,7 +103,7 @@ u64 stable_page_flags(struct page *page)
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 *
 	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
-	 * simple test in page_mapcount() is not enough.
+	 * simple test in page_mapped() is not enough.
 	 */
 	if (!PageSlab(page) && page_mapped(page))
 		u |= 1 << KPF_MMAP;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sscanf-implement-basic-character-sets-fix.patch

