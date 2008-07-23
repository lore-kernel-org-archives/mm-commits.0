From: akpm@linux-foundation.org
Subject: - page_align-mips-fix-implicit-declarations-of-function-page_align.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:13:21 -0700
Message-ID: <200807232325.m6NNPwLg017652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbYGWX0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     page_align: mips: fix implicit declarations of function 'PAGE_ALIGN'
has been removed from the -mm tree.  Its filename was
     page_align-mips-fix-implicit-declarations-of-function-page_align.patch

This patch was dropped because it was folded into page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_align: mips: fix implicit declarations of function 'PAGE_ALIGN'
From: Andrea Righi <righi.andrea@gmail.com>

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/module.c        |    1 +
 arch/mips/sgi-ip27/ip27-klnuma.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/mips/kernel/module.c~page_align-mips-fix-implicit-declarations-of-function-page_align arch/mips/kernel/module.c
--- a/arch/mips/kernel/module.c~page_align-mips-fix-implicit-declarations-of-function-page_align
+++ a/arch/mips/kernel/module.c
@@ -22,6 +22,7 @@
 
 #include <linux/moduleloader.h>
 #include <linux/elf.h>
+#include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
diff -puN arch/mips/sgi-ip27/ip27-klnuma.c~page_align-mips-fix-implicit-declarations-of-function-page_align arch/mips/sgi-ip27/ip27-klnuma.c
--- a/arch/mips/sgi-ip27/ip27-klnuma.c~page_align-mips-fix-implicit-declarations-of-function-page_align
+++ a/arch/mips/sgi-ip27/ip27-klnuma.c
@@ -4,6 +4,7 @@
  * Copyright 2000 - 2001 Kanoj Sarcar (kanoj@sgi.com)
  */
 #include <linux/init.h>
+#include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/kernel.h>
 #include <linux/nodemask.h>
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-mips-fix-implicit-declarations-of-function-page_align.patch
page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch
page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch

