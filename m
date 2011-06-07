From: akpm@linux-foundation.org
Subject: + include-asm-generic-pgtableh-fix-unbalanced-parenthesis.patch added to -mm tree
Date: Tue, 07 Jun 2011 14:43:04 -0700
Message-ID: <201106072143.p57Lh4x4028702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899Ab1FGVn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 17:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikai@nikai.net, aarcange@redhat.com


The patch titled
     include/asm-generic/pgtable.h: fix unbalanced parenthesis
has been added to the -mm tree.  Its filename is
     include-asm-generic-pgtableh-fix-unbalanced-parenthesis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/asm-generic/pgtable.h: fix unbalanced parenthesis
From: Nicolas Kaiser <nikai@nikai.net>

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/pgtable.h~include-asm-generic-pgtableh-fix-unbalanced-parenthesis include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~include-asm-generic-pgtableh-fix-unbalanced-parenthesis
+++ a/include/asm-generic/pgtable.h
@@ -88,7 +88,7 @@ static inline pmd_t pmdp_get_and_clear(s
 	pmd_t pmd = *pmdp;
 	pmd_clear(mm, address, pmdp);
 	return pmd;
-})
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
_

Patches currently in -mm which might be from nikai@nikai.net are

include-asm-generic-pgtableh-fix-unbalanced-parenthesis.patch

