From: akpm@linux-foundation.org
Subject: - fix-vmic-compilation.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:46:47 -0700
Message-ID: <200706011746.l51Hkoq6015087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761211AbXFARrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     Fix vmi.c compilation
has been removed from the -mm tree.  Its filename was
     fix-vmic-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix vmi.c compilation
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/kernel/vmi.c~fix-vmic-compilation arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~fix-vmic-compilation
+++ a/arch/i386/kernel/vmi.c
@@ -27,6 +27,7 @@
 #include <linux/bootmem.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/sched.h>
 #include <asm/vmi.h>
 #include <asm/io.h>
 #include <asm/fixmap.h>
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
