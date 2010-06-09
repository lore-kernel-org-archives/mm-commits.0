From: akpm@linux-foundation.org
Subject: + alpha-h8300-m68k-remove-obsolete-asm-mdh-files.patch added to -mm tree
Date: Wed, 09 Jun 2010 14:05:25 -0700
Message-ID: <201006092105.o59L5Pfw021547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965Ab0FIVGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 17:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, arnd@arndb.de, ink@jurassic.park.msu.ru, rth@twiddle.net, ysato@users.sourceforge.jp


The patch titled
     alpha/h8300/m68k: remove obsolete <asm/md.h> files
has been added to the -mm tree.  Its filename is
     alpha-h8300-m68k-remove-obsolete-asm-mdh-files.patch

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
Subject: alpha/h8300/m68k: remove obsolete <asm/md.h> files
From: Geert Uytterhoeven <geert@linux-m68k.org>

Removal of these started in 2.3.43pre3, ca. 10 years ago.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/md.h |   13 -------------
 arch/h8300/include/asm/md.h |   13 -------------
 arch/m68k/include/asm/md.h  |   13 -------------
 3 files changed, 39 deletions(-)

diff -puN arch/alpha/include/asm/md.h~alpha-h8300-m68k-remove-obsolete-asm-mdh-files /dev/null
--- a/arch/alpha/include/asm/md.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* $Id: md.h,v 1.1 1997/12/15 15:11:48 jj Exp $
- * md.h: High speed xor_block operation for RAID4/5 
- *
- */
- 
-#ifndef __ASM_MD_H
-#define __ASM_MD_H
-
-/* #define HAVE_ARCH_XORBLOCK */
-
-#define MD_XORBLOCK_ALIGNMENT	sizeof(long)
-
-#endif /* __ASM_MD_H */
diff -puN arch/h8300/include/asm/md.h~alpha-h8300-m68k-remove-obsolete-asm-mdh-files /dev/null
--- a/arch/h8300/include/asm/md.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * md.h: High speed xor_block operation for RAID4/5 
- *
- */
- 
-#ifndef __ASM_MD_H
-#define __ASM_MD_H
-
-/* #define HAVE_ARCH_XORBLOCK */
-
-#define MD_XORBLOCK_ALIGNMENT	sizeof(long)
-
-#endif /* __ASM_MD_H */
diff -puN arch/m68k/include/asm/md.h~alpha-h8300-m68k-remove-obsolete-asm-mdh-files /dev/null
--- a/arch/m68k/include/asm/md.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * md.h: High speed xor_block operation for RAID4/5
- *
- */
-
-#ifndef __ASM_MD_H
-#define __ASM_MD_H
-
-/* #define HAVE_ARCH_XORBLOCK */
-
-#define MD_XORBLOCK_ALIGNMENT	sizeof(long)
