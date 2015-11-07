From: akpm@linux-foundation.org
Subject: [folded-merged]
 zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 16:11:39 -0800
Message-ID: <563d41bb.Bvi6pdBkGIoD5lFK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbbKGALk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:11:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-add-comments-for-inuse-to-zspage-v2-fix
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch

This patch was dropped because it was folded into zsmalloc-add-comments-for-inuse-to-zspage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-add-comments-for-inuse-to-zspage-v2-fix

fix grammar

Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-add-comments-for-inuse-to-zspage-v2-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-add-comments-for-inuse-to-zspage-v2-fix
+++ a/mm/zsmalloc.c
@@ -38,7 +38,7 @@
  *	page->lru: links together first pages of various zspages.
  *		Basically forming list of zspages in a fullness group.
  *	page->mapping: class index and fullness group of the zspage
- *	page->inuse: the pages number that is used in this zspage
+ *	page->inuse: the number of objects that are used in this zspage
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-reflow-comment.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
zsmalloc-add-comments-for-inuse-to-zspage.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

