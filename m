From: akpm@linux-foundation.org
Subject: [merged] mm-includecheck-fix-vmallocc.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:04:51 -0700
Message-ID: <200910092204.n99M4pN0020215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934690AbZJIWGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: includecheck fix: vmalloc.c
has been removed from the -mm tree.  Its filename was
     mm-includecheck-fix-vmallocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: includecheck fix: vmalloc.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  mm/vmalloc.c: linux/highmem.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
sched-fix-htmldocs-schedc.patch

