From: akpm@linux-foundation.org
Subject: + arch-alpha-removed-duplicate-includes.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:35:41 -0800
Message-ID: <200711060235.lA62Zfte032015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765AbXKFCgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:36:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: woodzy@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     arch/alpha: remove duplicate includes
has been added to the -mm tree.  Its filename is
     arch-alpha-removed-duplicate-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/alpha: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/setup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/alpha/kernel/setup.c~arch-alpha-removed-duplicate-includes arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~arch-alpha-removed-duplicate-includes
+++ a/arch/alpha/kernel/setup.c
@@ -58,7 +58,6 @@ static struct notifier_block alpha_panic
 #include <asm/system.h>
 #include <asm/hwrpb.h>
 #include <asm/dma.h>
-#include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/console.h>
 
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
