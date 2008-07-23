From: akpm@linux-foundation.org
Subject: - page_align-h8300-fix-implicit-declaration-of-function-page_align.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:13:15 -0700
Message-ID: <200807232325.m6NNPqOe017642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399AbYGWX0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:26:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     page_align: h8300: fix implicit declaration of function 'PAGE_ALIGN'
has been removed from the -mm tree.  Its filename was
     page_align-h8300-fix-implicit-declaration-of-function-page_align.patch

This patch was dropped because it was folded into page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_align: h8300: fix implicit declaration of function 'PAGE_ALIGN'
From: Andrea Righi <righi.andrea@gmail.com>

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/h8300/kernel/setup.c~page_align-h8300-fix-implicit-declaration-of-function-page_align arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c~page_align-h8300-fix-implicit-declaration-of-function-page_align
+++ a/arch/h8300/kernel/setup.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/fb.h>
 #include <linux/console.h>
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-h8300-fix-implicit-declaration-of-function-page_align.patch
page_align-m68k-fix-implicit-declaration-of-function-page_align.patch
page_align-m68knommu-fix-implicit-declaration-of-function-page_align.patch
page_align-mips-fix-implicit-declarations-of-function-page_align.patch
page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch
page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch

