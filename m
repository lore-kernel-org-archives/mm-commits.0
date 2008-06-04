From: akpm@linux-foundation.org
Subject: + fix-various-old-email-addresses-for-dwmw2.patch added to -mm tree
Date: Wed, 04 Jun 2008 01:59:26 -0700
Message-ID: <200806040859.m548xQOA013429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758874AbYFDI7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 04:59:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org


The patch titled
     Fix various old email addresses for dwmw2
has been added to the -mm tree.  Its filename is
     fix-various-old-email-addresses-for-dwmw2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix various old email addresses for dwmw2
From: David Woodhouse <dwmw2@infradead.org>

Although if people have questions about ARCnet, perhaps it's _better_
for them to be mailing dwmw2@cam.ac.uk about it...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/arcnet.txt   |    2 +-
 arch/frv/kernel/cmode.S               |    2 +-
 arch/frv/kernel/sleep.S               |    2 +-
 arch/frv/mb93090-mb00/pci-dma-nommu.c |    2 +-
 drivers/mtd/redboot.c                 |    2 +-
 fs/afs/callback.c                     |    2 +-
 fs/afs/inode.c                        |    2 +-
 fs/afs/super.c                        |    2 +-
 include/linux/mtd/nand.h              |    2 +-
 include/linux/tty.h                   |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/networking/arcnet.txt~fix-various-old-email-addresses-for-dwmw2 Documentation/networking/arcnet.txt
--- a/Documentation/networking/arcnet.txt~fix-various-old-email-addresses-for-dwmw2
+++ a/Documentation/networking/arcnet.txt
@@ -46,7 +46,7 @@ These are the ARCnet drivers for Linux.
 
 
 This new release (2.91) has been put together by David Woodhouse 
-<dwmw2@cam.ac.uk>, in an attempt to tidy up the driver after adding support 
+<dwmw2@infradead.org>, in an attempt to tidy up the driver after adding support
 for yet another chipset. Now the generic support has been separated from the
 individual chipset drivers, and the source files aren't quite so packed with
 #ifdefs! I've changed this file a bit, but kept it in the first person from
diff -puN arch/frv/kernel/cmode.S~fix-various-old-email-addresses-for-dwmw2 arch/frv/kernel/cmode.S
--- a/arch/frv/kernel/cmode.S~fix-various-old-email-addresses-for-dwmw2
+++ a/arch/frv/kernel/cmode.S
@@ -1,7 +1,7 @@
 /* cmode.S: clock mode management
  *
  * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Woodhouse (dwmw2@redhat.com)
+ * Written by David Woodhouse (dwmw2@infradead.org)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff -puN arch/frv/kernel/sleep.S~fix-various-old-email-addresses-for-dwmw2 arch/frv/kernel/sleep.S
--- a/arch/frv/kernel/sleep.S~fix-various-old-email-addresses-for-dwmw2
+++ a/arch/frv/kernel/sleep.S
@@ -1,7 +1,7 @@
 /* sleep.S: power saving mode entry
  *
  * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Woodhouse (dwmw2@redhat.com)
+ * Written by David Woodhouse (dwmw2@infradead.org)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff -puN arch/frv/mb93090-mb00/pci-dma-nommu.c~fix-various-old-email-addresses-for-dwmw2 arch/frv/mb93090-mb00/pci-dma-nommu.c
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c~fix-various-old-email-addresses-for-dwmw2
+++ a/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -1,7 +1,7 @@
 /* pci-dma-nommu.c: Dynamic DMA mapping support for the FRV
  *
  * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Woodhouse (dwmw2@redhat.com)
+ * Written by David Woodhouse (dwmw2@infradead.org)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff -puN drivers/mtd/redboot.c~fix-various-old-email-addresses-for-dwmw2 drivers/mtd/redboot.c
--- a/drivers/mtd/redboot.c~fix-various-old-email-addresses-for-dwmw2
+++ a/drivers/mtd/redboot.c
@@ -295,5 +295,5 @@ module_init(redboot_parser_init);
 module_exit(redboot_parser_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Red Hat, Inc. - David Woodhouse <dwmw2@cambridge.redhat.com>");
+MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_DESCRIPTION("Parsing code for RedBoot Flash Image System (FIS) tables");
diff -puN fs/afs/callback.c~fix-various-old-email-addresses-for-dwmw2 fs/afs/callback.c
--- a/fs/afs/callback.c~fix-various-old-email-addresses-for-dwmw2
+++ a/fs/afs/callback.c
@@ -8,7 +8,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * Authors: David Woodhouse <dwmw2@cambridge.redhat.com>
+ * Authors: David Woodhouse <dwmw2@infradead.org>
  *          David Howells <dhowells@redhat.com>
  *
  */
diff -puN fs/afs/inode.c~fix-various-old-email-addresses-for-dwmw2 fs/afs/inode.c
--- a/fs/afs/inode.c~fix-various-old-email-addresses-for-dwmw2
+++ a/fs/afs/inode.c
@@ -8,7 +8,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * Authors: David Woodhouse <dwmw2@cambridge.redhat.com>
+ * Authors: David Woodhouse <dwmw2@infradead.org>
  *          David Howells <dhowells@redhat.com>
  *
  */
diff -puN fs/afs/super.c~fix-various-old-email-addresses-for-dwmw2 fs/afs/super.c
--- a/fs/afs/super.c~fix-various-old-email-addresses-for-dwmw2
+++ a/fs/afs/super.c
@@ -10,7 +10,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  * Authors: David Howells <dhowells@redhat.com>
- *          David Woodhouse <dwmw2@redhat.com>
+ *          David Woodhouse <dwmw2@infradead.org>
  *
  */
 
diff -puN include/linux/mtd/nand.h~fix-various-old-email-addresses-for-dwmw2 include/linux/mtd/nand.h
--- a/include/linux/mtd/nand.h~fix-various-old-email-addresses-for-dwmw2
+++ a/include/linux/mtd/nand.h
@@ -1,7 +1,7 @@
 /*
  *  linux/include/linux/mtd/nand.h
  *
- *  Copyright (c) 2000 David Woodhouse <dwmw2@mvhi.com>
+ *  Copyright (c) 2000 David Woodhouse <dwmw2@infradead.org>
  *                     Steven J. Hill <sjhill@realitydiluted.com>
  *		       Thomas Gleixner <tglx@linutronix.de>
  *
diff -puN include/linux/tty.h~fix-various-old-email-addresses-for-dwmw2 include/linux/tty.h
--- a/include/linux/tty.h~fix-various-old-email-addresses-for-dwmw2
+++ a/include/linux/tty.h
@@ -36,7 +36,7 @@
 #define N_6PACK		7
 #define N_MASC		8	/* Reserved for Mobitex module <kaz@cafe.net> */
 #define N_R3964		9	/* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10	/* Reserved for Profibus <Dave@mvhi.com> */
+#define N_PROFIBUS_FDL	10	/* Reserved for Profibus */
 #define N_IRDA		11	/* Linux IrDa - http://irda.sourceforge.net/ */
 #define N_SMSBLOCK	12	/* SMS block mode - for talking to GSM data */
 				/* cards about SMS messages */
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
fix-various-old-email-addresses-for-dwmw2.patch
linux-next.patch
git-embedded.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
git-battery.patch
rtc-class-driver-for-ppc_md-rtc-functions.patch
rtc-class-driver-for-ppc_md-rtc-functions-fix.patch
mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch
mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up.patch

