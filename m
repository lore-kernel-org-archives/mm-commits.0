From: akpm@linux-foundation.org
Subject: + powerpc-enable-ubsan-support-fix.patch added to -mm tree
Date: Fri, 11 Dec 2015 14:11:43 -0800
Message-ID: <566b4a1f.qyET3B7tLXob7p5Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbbLKWLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 17:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valentinrothberg@gmail.com, aryabinin@virtuozzo.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/Kconfig: fix typo in select statement
has been added to the -mm tree.  Its filename is
     powerpc-enable-ubsan-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-enable-ubsan-support-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-enable-ubsan-support-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: arch/powerpc/Kconfig: fix typo in select statement

The 'I' in sanitize was missing:
s/ARCH_HAS_UBSAN_SANTIZE_ALL/ARCH_HAS_UBSAN_SANITIZE_ALL/

Fixes: 257e4ee82dbd ("powerpc: enable UBSAN support")
Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/Kconfig~powerpc-enable-ubsan-support-fix arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-enable-ubsan-support-fix
+++ a/arch/powerpc/Kconfig
@@ -158,7 +158,7 @@ config PPC
 	select EDAC_ATOMIC_SCRUB
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
 	select HAVE_ARCH_SECCOMP_FILTER
-	select ARCH_HAS_UBSAN_SANTIZE_ALL
+	select ARCH_HAS_UBSAN_SANITIZE_ALL
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
_

Patches currently in -mm which might be from valentinrothberg@gmail.com are

powerpc-enable-ubsan-support-fix.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix.patch

