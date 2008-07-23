From: akpm@linux-foundation.org
Subject: - page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:13:23 -0700
Message-ID: <200807232326.m6NNQ0ni017655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504AbYGWX0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     page_align: xtensa: fix implicit declaration of function 'PAGE_ALIGN'
has been removed from the -mm tree.  Its filename was
     page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch

This patch was dropped because it was folded into page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_align: xtensa: fix implicit declaration of function 'PAGE_ALIGN'
From: Andrea Righi <righi.andrea@gmail.com>

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/xtensa/kernel/setup.c~page_align-xtensa-fix-implicit-declaration-of-function-page_align arch/xtensa/kernel/setup.c
--- a/arch/xtensa/kernel/setup.c~page_align-xtensa-fix-implicit-declaration-of-function-page_align
+++ a/arch/xtensa/kernel/setup.c
@@ -16,6 +16,7 @@
 
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/screen_info.h>
 #include <linux/bootmem.h>
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch
page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch

