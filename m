From: akpm@linux-foundation.org
Subject: + rapidio-move-include-asm-ppc-rioh-to-include-asm-powerpc-rioh.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:24:06 -0700
Message-ID: <200803120424.m2C4O6oR009819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbYCLEYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wei.zhang@freescale.com


The patch titled
     rapidio: move include/asm-ppc/rio.h to include/asm-powerpc/rio.h
has been added to the -mm tree.  Its filename is
     rapidio-move-include-asm-ppc-rioh-to-include-asm-powerpc-rioh.patch

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
Subject: rapidio: move include/asm-ppc/rio.h to include/asm-powerpc/rio.h
From: Zhang Wei <wei.zhang@freescale.com>

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/rio.h |   18 ++++++++++++++++++
 include/asm-ppc/rio.h     |   18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff -puN /dev/null include/asm-powerpc/rio.h
--- /dev/null
+++ a/include/asm-powerpc/rio.h
@@ -0,0 +1,18 @@
+/*
+ * RapidIO architecture support
+ *
+ * Copyright 2005 MontaVista Software, Inc.
+ * Matt Porter <mporter@kernel.crashing.org>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef ASM_PPC_RIO_H
+#define ASM_PPC_RIO_H
+
+extern void platform_rio_init(void);
+
+#endif				/* ASM_PPC_RIO_H */
diff -puN include/asm-ppc/rio.h~rapidio-move-include-asm-ppc-rioh-to-include-asm-powerpc-rioh /dev/null
--- a/include/asm-ppc/rio.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * RapidIO architecture support
- *
- * Copyright 2005 MontaVista Software, Inc.
- * Matt Porter <mporter@kernel.crashing.org>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef ASM_PPC_RIO_H
-#define ASM_PPC_RIO_H
-
-extern void platform_rio_init(void);
