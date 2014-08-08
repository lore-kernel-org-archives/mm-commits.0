From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
 removed from -mm tree
Date: Fri, 08 Aug 2014 14:00:22 -0700
Message-ID: <53e53a66.jOj3YXLuAT4bpE0J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:58664 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144AbaHHVAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:00:23 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1561099pdj.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:00:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, benh@kernel.crashing.org, lauraa@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig fix
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch

This patch was dropped because it was folded into lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig fix

powerpc files now need asm/dma.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/dma-noncoherent.c |    1 +
 arch/powerpc/platforms/44x/warp.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/powerpc/mm/dma-noncoherent.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3 arch/powerpc/mm/dma-noncoherent.c
--- a/arch/powerpc/mm/dma-noncoherent.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3
+++ a/arch/powerpc/mm/dma-noncoherent.c
@@ -33,6 +33,7 @@
 #include <linux/export.h>
 
 #include <asm/tlbflush.h>
+#include <asm/dma.h>
 
 #include "mmu_decl.h"
 
diff -puN arch/powerpc/platforms/44x/warp.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3 arch/powerpc/platforms/44x/warp.c
--- a/arch/powerpc/platforms/44x/warp.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3
+++ a/arch/powerpc/platforms/44x/warp.c
@@ -25,6 +25,7 @@
 #include <asm/time.h>
 #include <asm/uic.h>
 #include <asm/ppc4xx.h>
+#include <asm/dma.h>
 
 
 static __initdata struct of_device_id warp_of_bus[] = {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
purgatory-core-purgatory-functionality-fix.patch

