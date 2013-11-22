From: akpm@linux-foundation.org
Subject: + init-mainc-remove-unused-declaration-of-tc_init.patch added to
 -mm tree
Date: Thu, 21 Nov 2013 16:37:24 -0800
Message-ID: <528ea744.XIaq9XP7CKtg8zhp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3KVAhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 19:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + init-mainc-remove-unused-declaration-of-tc_init.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 16:37:24 -0800


The patch titled
     Subject: init/main.c: remove unused declaration of tc_init()
has been added to the -mm tree.  Its filename is
     init-mainc-remove-unused-declaration-of-tc_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-remove-unused-declaration-of-tc_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-remove-unused-declaration-of-tc_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: init/main.c: remove unused declaration of tc_init()

Its user was removed in v2.5.2.4.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN init/main.c~init-mainc-remove-unused-declaration-of-tc_init init/main.c
--- a/init/main.c~init-mainc-remove-unused-declaration-of-tc_init
+++ a/init/main.c
@@ -99,10 +99,6 @@ extern void radix_tree_init(void);
 static inline void mark_rodata_ro(void) { }
 #endif
 
-#ifdef CONFIG_TC
-extern void tc_init(void);
-#endif
