From: akpm@linux-foundation.org
Subject: - arch-alpha-removed-duplicate-includes.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:45 -0800
Message-ID: <200802052233.m15MXQBb012427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53630 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762638AbYBEWmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     arch/alpha: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-alpha-removed-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-xtensa.patch
