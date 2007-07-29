From: akpm@linux-foundation.org
Subject: + xtensa-consolec-remove-duplicate-include.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:48:58 -0700
Message-ID: <200707290648.l6T6mw3i012365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759648AbXG2GtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, czankel@tensilica.com, frederik.deweerdt@gmail.com


The patch titled
     xtensa console.c: remove duplicate #include
has been added to the -mm tree.  Its filename is
     xtensa-consolec-remove-duplicate-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xtensa console.c: remove duplicate #include
From: Frederik Deweerdt <deweerdt@free.fr>

This patch removes one of the two linux/console.h included in
arch/xtensa/platform-iss/console.c

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Chris Zankel <czankel@tensilica.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platform-iss/console.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/xtensa/platform-iss/console.c~xtensa-consolec-remove-duplicate-include arch/xtensa/platform-iss/console.c
--- a/arch/xtensa/platform-iss/console.c~xtensa-consolec-remove-duplicate-include
+++ a/arch/xtensa/platform-iss/console.c
@@ -20,7 +20,6 @@
 #include <linux/param.h>
 #include <linux/serial.h>
 #include <linux/serialP.h>
-#include <linux/console.h>
 
 #include <asm/uaccess.h>
 #include <asm/irq.h>
_

Patches currently in -mm which might be from deweerdt@free.fr are

xtensa-consolec-remove-duplicate-include.patch
revoke-core-code.patch
reiser4-sb_sync_inodes.patch
