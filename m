From: akpm@linux-foundation.org
Subject: + x86-fix-incomplete-include-guard.patch added to -mm tree
Date: Thu, 29 May 2008 00:42:38 -0700
Message-ID: <200805290742.m4T7gcZk023004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbYE2HnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 03:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com


The patch titled
     x86: fix incomplete include guard
has been added to the -mm tree.  Its filename is
     x86-fix-incomplete-include-guard.patch

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

mn10300-fix-typo-in-header-guard.patch
x86-fix-incomplete-include-guard.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
h8300-fix-typo-in-header-guard.patch
v850-fix-typo-in-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch

