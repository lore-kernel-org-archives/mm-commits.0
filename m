From: akpm@linux-foundation.org
Subject: + arch-parisc-remove-duplicate-includes.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:35:52 -0800
Message-ID: <200711060235.lA62ZqGK032027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbXKFCf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:35:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: woodzy@gmail.com, kyle@mcmartin.ca


The patch titled
     arch/parisc: remove duplicate includes
has been added to the -mm tree.  Its filename is
     arch-parisc-remove-duplicate-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

arch-alpha-removed-duplicate-includes.patch
arch-arm-removed-duplicate-includes.patch
arch-ia64-remove-duplicate-includes.patch
arch-mips-remove-duplicate-includes.patch
arch-parisc-remove-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
arch-sparc-remove-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch
