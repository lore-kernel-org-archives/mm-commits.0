From: akpm@linux-foundation.org
Subject: - x86-fix-incomplete-include-guard.patch removed from -mm tree
Date: Tue, 03 Jun 2008 12:02:37 -0700
Message-ID: <200806031902.m53J2bv8014812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755227AbYFCTDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     x86: fix incomplete include guard
has been removed from the -mm tree.  Its filename was
     x86-fix-incomplete-include-guard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix incomplete include guard
From: Vegard Nossum <vegard.nossum@gmail.com>

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/seccomp_32.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-x86/seccomp_32.h~x86-fix-incomplete-include-guard include/asm-x86/seccomp_32.h
--- a/include/asm-x86/seccomp_32.h~x86-fix-incomplete-include-guard
+++ a/include/asm-x86/seccomp_32.h
@@ -1,4 +1,5 @@
 #ifndef _ASM_SECCOMP_H
+#define _ASM_SECCOMP_H
 
 #include <linux/thread_info.h>
 
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
h8300-fix-typo-in-header-guard.patch
v850-fix-typo-in-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch

