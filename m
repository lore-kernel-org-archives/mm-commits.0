From: akpm@linux-foundation.org
Subject: + mm-includecheck-fix-vmallocc.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:16:44 -0700
Message-ID: <200909242216.n8OMGiAQ029455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260AbZIXWSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com


The patch titled
     mm: includecheck fix: vmalloc.c
has been added to the -mm tree.  Its filename is
     mm-includecheck-fix-vmallocc.patch

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
Subject: mm: includecheck fix: vmalloc.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  mm/vmalloc.c: linux/highmem.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/vmalloc.c~mm-includecheck-fix-vmallocc mm/vmalloc.c
--- a/mm/vmalloc.c~mm-includecheck-fix-vmallocc
+++ a/mm/vmalloc.c
@@ -25,7 +25,6 @@
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
-#include <linux/highmem.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
mm-includecheck-fix-vmallocc.patch
mtd-nand-fix-htmldocs-warnings.patch

