From: akpm@linux-foundation.org
Subject: + page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch added to -mm tree
Date: Thu, 03 Jul 2008 10:09:54 -0700
Message-ID: <200807031709.m63H9sIi017764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbYGCRRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 13:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com


The patch titled
     page_align: xtensa: fix implicit declaration of function 'PAGE_ALIGN'
has been added to the -mm tree.  Its filename is
     page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch

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

cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
page_align-arm-fix-implicit-declaration-of-function-page_align.patch
page_align-avr32-fix-implicit-declaration-of-function-page_align.patch
page_align-h8300-fix-implicit-declaration-of-function-page_align.patch
page_align-m68k-fix-implicit-declaration-of-function-page_align.patch
page_align-m68knommu-fix-implicit-declaration-of-function-page_align.patch
page_align-mips-fix-implicit-declarations-of-function-page_align.patch
page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch
page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch
distinct-tgid-tid-i-o-statistics.patch

