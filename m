From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-add-comments-for-inuse-to-zspage.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:45:06 -0800
Message-ID: <5640f7c2.B5YLcm2RChjlhGb2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbbKITpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhuhui@xiaomi.com, ddstreet@ieee.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: add comments for ->inuse to zspage
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-comments-for-inuse-to-zspage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Zhu <zhuhui@xiaomi.com>
Subject: zsmalloc: add comments for ->inuse to zspage

[akpm@linux-foundation.org: fix grammar]
Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/zsmalloc.c~zsmalloc-add-comments-for-inuse-to-zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-add-comments-for-inuse-to-zspage
+++ a/mm/zsmalloc.c
@@ -38,6 +38,7 @@
  *	page->lru: links together first pages of various zspages.
  *		Basically forming list of zspages in a fullness group.
  *	page->mapping: class index and fullness group of the zspage
+ *	page->inuse: the number of objects that are used in this zspage
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
_

Patches currently in -mm which might be from zhuhui@xiaomi.com are


