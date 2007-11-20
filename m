From: akpm@linux-foundation.org
Subject: + mac68k-remove-dead-code.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:15:11 -0800
Message-ID: <200711200215.lAK2FBD7008970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760396AbXKTCP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fthain@telegraphics.com.au, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     mac68k: remove dead code
has been added to the -mm tree.  Its filename is
     mac68k-remove-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mac68k-mailing-list-addresss.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
