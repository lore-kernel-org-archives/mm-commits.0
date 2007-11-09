From: akpm@linux-foundation.org
Subject: - arch-ia64-remove-duplicate-includes.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:09 -0800
Message-ID: <200711091913.lA9JD93w027986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841AbXKITNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, horms@verge.net.au, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/ia64: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-ia64-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/ia64: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/ia32priv.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/ia64/ia32/ia32priv.h~arch-ia64-remove-duplicate-includes arch/ia64/ia32/ia32priv.h
--- a/arch/ia64/ia32/ia32priv.h~arch-ia64-remove-duplicate-includes
+++ a/arch/ia64/ia32/ia32priv.h
@@ -290,7 +290,6 @@ struct old_linux32_dirent {
 #define _ASM_IA64_ELF_H		/* Don't include elf.h */
 
 #include <linux/sched.h>
-#include <asm/processor.h>
 
 /*
  * This is used to ensure we don't load something for the wrong architecture.
_

Patches currently in -mm which might be from woodzy@gmail.com are

arch-arm-removed-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
git-ia64.patch
git-mips.patch
arch-parisc-remove-duplicate-includes.patch
git-sparc64.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch
arch-alpha-removed-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
