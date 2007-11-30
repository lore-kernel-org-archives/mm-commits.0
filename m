From: akpm@linux-foundation.org
Subject: - arch-parisc-remove-duplicate-includes.patch removed from -mm tree
Date: Thu, 29 Nov 2007 23:03:34 -0800
Message-ID: <200711300703.lAU73YF8027947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757995AbXK3HDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 02:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     arch/parisc: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-parisc-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/parisc: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/signal.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/parisc/kernel/signal.c~arch-parisc-remove-duplicate-includes arch/parisc/kernel/signal.c
--- a/arch/parisc/kernel/signal.c~arch-parisc-remove-duplicate-includes
+++ a/arch/parisc/kernel/signal.c
@@ -23,7 +23,6 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
-#include <linux/compat.h>
 #include <linux/elf.h>
 #include <asm/ucontext.h>
 #include <asm/rt_sigframe.h>
_

Patches currently in -mm which might be from woodzy@gmail.com are

git-arm.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
git-mips.patch
arch-parisc-remove-duplicate-includes.patch
git-x86.patch
arch-xtensa-remove-duplicate-includes.patch
arch-alpha-removed-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
