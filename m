From: akpm@linux-foundation.org
Subject: - config_highpte-vs-sub-page-page-tables-fix-2.patch removed from -mm tree
Date: Fri, 01 Feb 2008 15:07:40 -0800
Message-ID: <200802012316.m11NGMqb003686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761562AbYBAXQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 18:16:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, benh@kernel.crashing.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     parisc: balance parenthesis in pte_free_kernel()
has been removed from the -mm tree.  Its filename was
     config_highpte-vs-sub-page-page-tables-fix-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: balance parenthesis in pte_free_kernel()
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Another parenthesis fix.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-parisc/pgalloc.h~config_highpte-vs-sub-page-page-tables-fix-2 include/asm-parisc/pgalloc.h
--- a/include/asm-parisc/pgalloc.h~config_highpte-vs-sub-page-page-tables-fix-2
+++ a/include/asm-parisc/pgalloc.h
@@ -141,7 +141,7 @@ static inline void pte_free_kernel(struc
 static inline void pte_free_kernel(struct mm_struct *mm, struct page *pte)
 {
 	pgtable_page_dtor(pte);
-	pte_free_kernel(page_address((pte));
+	pte_free_kernel(page_address(pte));
 }
 
 #define check_pgt_cache()	do { } while (0)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
include-asm-powerpc-nvramh-needs-listh.patch
git-mmc.patch
maps4-add-proc-kpageflags-interface-fix-2.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
config_highpte-vs-sub-page-page-tables-fix-2.patch
ext3-remove-unused-code-from-ext3_find_entry.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
reiser4.patch
