From: akpm@linux-foundation.org
Subject: [merged] fs-includecheck-fix-proc-kcorec.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:04:53 -0700
Message-ID: <200910092204.n99M4rk1020257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934700AbZJIWGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: includecheck fix: proc, kcore.c
has been removed from the -mm tree.  Its filename was
     fs-includecheck-fix-proc-kcorec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: includecheck fix: proc, kcore.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  fs/proc/kcore.c: linux/mm.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/proc/kcore.c~fs-includecheck-fix-proc-kcorec fs/proc/kcore.c
--- a/fs/proc/kcore.c~fs-includecheck-fix-proc-kcorec
+++ a/fs/proc/kcore.c
@@ -23,7 +23,6 @@
 #include <asm/io.h>
 #include <linux/list.h>
 #include <linux/ioport.h>
-#include <linux/mm.h>
 #include <linux/memory.h>
 #include <asm/sections.h>
 
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
sched-fix-htmldocs-schedc.patch

