From: akpm@linux-foundation.org
Subject: [merged] init-mainc-remove-unused-declaration-of-tc_init.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:12 -0800
Message-ID: <52e2b8b4.XfslqMCyrG10vCPf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaAXTCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: [merged] init-mainc-remove-unused-declaration-of-tc_init.patch removed from -mm tree
To: geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:12 -0800


The patch titled
     Subject: init/main.c: remove unused declaration of tc_init()
has been removed from the -mm tree.  Its filename was
     init-mainc-remove-unused-declaration-of-tc_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
