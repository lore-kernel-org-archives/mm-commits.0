From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext.patch removed from -mm tree
Date: Mon, 23 May 2016 12:46:23 -0700
Message-ID: <57435e0f.hW1F4AXC5MV5hxcS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbcEWTqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm fix commmets: if SPARSEMEM, pgdata doesn't have page_ext
has been removed from the -mm tree.  Its filename was
     mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm fix commmets: if SPARSEMEM, pgdata doesn't have page_ext

If SPARSEMEM, use page_ext in mem_section
if !SPARSEMEM, use page_ext in pgdata

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext
+++ a/include/linux/mmzone.h
@@ -1063,7 +1063,7 @@ struct mem_section {
 	unsigned long *pageblock_flags;
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
-	 * If !SPARSEMEM, pgdat doesn't have page_ext pointer. We use
+	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
_

Patches currently in -mm which might be from weijie.yang@samsung.com are


