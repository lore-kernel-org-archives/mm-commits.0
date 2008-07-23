From: akpm@linux-foundation.org
Subject: - page_align-avr32-fix-implicit-declaration-of-function-page_align.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:13:13 -0700
Message-ID: <200807232325.m6NNPoRX017639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbYGWXZw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:25:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     page_align: avr32: fix implicit declaration of function 'PAGE_ALIGN'
has been removed from the -mm tree.  Its filename was
     page_align-avr32-fix-implicit-declaration-of-function-page_align.patch

This patch was dropped because it was folded into page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_align: avr32: fix implicit declaration of function 'PAGE_ALIGN'
From: Andrea Righi <righi.andrea@gmail.com>

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/ioremap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/avr32/mm/ioremap.c~page_align-avr32-fix-implicit-declaration-of-function-page_align arch/avr32/mm/ioremap.c
--- a/arch/avr32/mm/ioremap.c~page_align-avr32-fix-implicit-declaration-of-function-page_align
+++ a/arch/avr32/mm/ioremap.c
@@ -6,6 +6,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/io.h>
 
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-avr32-fix-implicit-declaration-of-function-page_align.patch
page_align-h8300-fix-implicit-declaration-of-function-page_align.patch
page_align-m68k-fix-implicit-declaration-of-function-page_align.patch
page_align-m68knommu-fix-implicit-declaration-of-function-page_align.patch
page_align-mips-fix-implicit-declarations-of-function-page_align.patch
page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch
page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch

