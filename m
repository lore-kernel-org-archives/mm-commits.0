From: akpm@linux-foundation.org
Subject: - cris-remove-unused-global_flush_tlb.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:45 -0700
Message-ID: <200807242325.m6ONPjng010909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755590AbYGXXZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@intellilink.co.jp, fernando@oss.ntt.co.jp, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: remove unused global_flush_tlb
has been removed from the -mm tree.  Its filename was
     cris-remove-unused-global_flush_tlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: remove unused global_flush_tlb
From: Fernando Luis Vazquez Cao <fernando@intellilink.co.jp>

global_flush_tlb is declared but never used.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/cacheflush.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-cris/cacheflush.h~cris-remove-unused-global_flush_tlb include/asm-cris/cacheflush.h
--- a/include/asm-cris/cacheflush.h~cris-remove-unused-global_flush_tlb
+++ a/include/asm-cris/cacheflush.h
@@ -26,7 +26,6 @@
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-void global_flush_tlb(void); 
 int change_page_attr(struct page *page, int numpages, pgprot_t prot);
 
 #endif /* _CRIS_CACHEFLUSH_H */
_

Patches currently in -mm which might be from fernando@intellilink.co.jp are

origin.patch

