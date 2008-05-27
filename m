From: akpm@linux-foundation.org
Subject: + cris-remove-unused-global_flush_tlb.patch added to -mm tree
Date: Tue, 27 May 2008 16:13:47 -0700
Message-ID: <200805272313.m4RNDl21018000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbYE0XN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 19:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@intellilink.co.jp, fernando@oss.ntt.co.jp, starvik@axis.com


The patch titled
     cris: remove unused global_flush_tlb
has been added to the -mm tree.  Its filename is
     cris-remove-unused-global_flush_tlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cris-remove-unused-global_flush_tlb.patch

