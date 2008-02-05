From: akpm@linux-foundation.org
Subject: - mac68k-remove-dead-code.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:59 -0800
Message-ID: <200802052234.m15MYeqr012543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760990AbYBEWmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fthain@telegraphics.com.au, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     mac68k: remove dead code
has been removed from the -mm tree.  Its filename was
     mac68k-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac68k: remove dead code
From: Finn Thain <fthain@telegraphics.com.au>

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mac/config.c       |    2 --
 include/asm-m68k/macintosh.h |    2 --
 2 files changed, 4 deletions(-)

diff -puN arch/m68k/mac/config.c~mac68k-remove-dead-code arch/m68k/mac/config.c
--- a/arch/m68k/mac/config.c~mac68k-remove-dead-code
+++ a/arch/m68k/mac/config.c
@@ -58,8 +58,6 @@ extern struct mem_info m68k_memory[NUM_M
 
 extern struct mem_info m68k_ramdisk;
 
-extern char m68k_command_line[CL_SIZE];
-
 void *mac_env;					/* Loaded by the boot asm */
 
 /* The phys. video addr. - might be bogus on some machines */
diff -puN include/asm-m68k/macintosh.h~mac68k-remove-dead-code include/asm-m68k/macintosh.h
--- a/include/asm-m68k/macintosh.h~mac68k-remove-dead-code
+++ a/include/asm-m68k/macintosh.h
@@ -14,8 +14,6 @@ extern void mac_init_IRQ(void);
 extern int mac_irq_pending(unsigned int);
 extern void mac_identify(void);
 extern void mac_report_hardware(void);
-extern void mac_debugging_penguin(int);
-extern void mac_boom(int);
 
 /*
  *	Floppy driver magic hook - probably shouldnt be here
_

Patches currently in -mm which might be from fthain@telegraphics.com.au are

origin.patch
