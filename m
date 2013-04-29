From: akpm@linux-foundation.org
Subject: [folded-merged] early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 15:59:30 -0700
Message-ID: <20130429225930.AAA9B5A41E8@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:37871 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3D2W7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 18:59:31 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so116436vbe.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 15:59:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, paul.gortmaker@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: early_printk-consolidate-random-copies-of-identical-code-v3-fix
has been removed from the -mm tree.  Its filename was
     early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch

This patch was dropped because it was folded into early_printk-consolidate-random-copies-of-identical-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: early_printk-consolidate-random-copies-of-identical-code-v3-fix

arch/mips/kernel/early_printk.c needs kernel.h for va_list

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/early_printk.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mips/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code-v3-fix arch/mips/kernel/early_printk.c
--- a/arch/mips/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code-v3-fix
+++ a/arch/mips/kernel/early_printk.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2007 MIPS Technologies, Inc.
  *   written by Ralf Baechle (ralf@linux-mips.org)
  */
+#include <linux/kernel.h>
 #include <linux/console.h>
 #include <linux/printk.h>
 #include <linux/init.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


