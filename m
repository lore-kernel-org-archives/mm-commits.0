From: akpm@linux-foundation.org
Subject: + arch-x86-mm-gupc-fix-minor-spelling-error-in-comments.patch added to -mm tree
Date: Fri, 22 Jan 2010 14:53:05 -0800
Message-ID: <201001222253.o0MMr5Ot000968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab0AVWxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 17:53:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, mingo@elte.hu


The patch titled
     arch/x86/mm/gup.c: fix minor spelling error in comments
has been added to the -mm tree.  Its filename is
     arch-x86-mm-gupc-fix-minor-spelling-error-in-comments.patch

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
Subject: arch/x86/mm/gup.c: fix minor spelling error in comments
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/gup.c~arch-x86-mm-gupc-fix-minor-spelling-error-in-comments arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~arch-x86-mm-gupc-fix-minor-spelling-error-in-comments
+++ a/arch/x86/mm/gup.c
@@ -18,7 +18,7 @@ static inline pte_t gup_get_pte(pte_t *p
 #else
 	/*
 	 * With get_user_pages_fast, we walk down the pagetables without taking
-	 * any locks.  For this we would like to load the pointers atoimcally,
+	 * any locks.  For this we would like to load the pointers atomically,
 	 * but that is not possible (without expensive cmpxchg8b) on PAE.  What
 	 * we do have is the guarantee that a pte will only either go from not
 	 * present to present, or present to not present or both -- it will not
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
arch-x86-mm-gupc-fix-minor-spelling-error-in-comments.patch
drm-dont-use-own-implementation-of-atoi.patch
staging-dont-use-custom-implementation-of-atoi.patch

