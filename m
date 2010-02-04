From: akpm@linux-foundation.org
Subject: [merged] arch-x86-mm-gupc-fix-minor-spelling-error-in-comments.patch removed from -mm tree
Date: Thu, 04 Feb 2010 09:49:04 -0800
Message-ID: <201002041749.o14Hn4PN011984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab0BDRti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 12:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-andriy.shevchenko@nokia.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     arch/x86/mm/gup.c: fix minor spelling error in comments
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-gupc-fix-minor-spelling-error-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
drm-dont-use-own-implementation-of-atoi.patch

