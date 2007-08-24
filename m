From: akpm@linux-foundation.org
Subject: - m68k-kill-superfluous-extern.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:04 -0700
Message-ID: <200708242056.l7OKu4SP014006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50004 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761919AbXHXVIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: Kill superfluous extern
has been removed from the -mm tree.  Its filename was
     m68k-kill-superfluous-extern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: Kill superfluous extern
From: Geert Uytterhoeven <geert@linux-m68k.org>

Kill a superfluous extern declaration

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/motorola.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/m68k/mm/motorola.c~m68k-kill-superfluous-extern arch/m68k/mm/motorola.c
--- a/arch/m68k/mm/motorola.c~m68k-kill-superfluous-extern
+++ a/arch/m68k/mm/motorola.c
@@ -210,11 +210,7 @@ void __init paging_init(void)
 	int i;
 
 #ifdef DEBUG
-	{
-		extern unsigned long availmem;
-		printk ("start of paging_init (%p, %lx)\n",
-			kernel_pg_dir, availmem);
-	}
+	printk ("start of paging_init (%p, %lx)\n", kernel_pg_dir, availmem);
 #endif
 
 	/* Fix the cache mode in the page descriptors for the 680[46]0.  */
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
