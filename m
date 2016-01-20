From: akpm@linux-foundation.org
Subject: [folded-merged] powerpc-enable-ubsan-support-fix.patch removed
 from -mm tree
Date: Wed, 20 Jan 2016 14:37:12 -0800
Message-ID: <56a00c18.2oWHnbn8VBkr8FAA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbcATWhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:37:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valentinrothberg@gmail.com, aryabinin@virtuozzo.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/Kconfig: fix typo in select statement
has been removed from the -mm tree.  Its filename was
     powerpc-enable-ubsan-support-fix.patch

This patch was dropped because it was folded into powerpc-enable-ubsan-support.patch

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
@@ -159,7 +159,7 @@ config PPC
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select HAVE_ARCH_SECCOMP_FILTER
-	select ARCH_HAS_UBSAN_SANTIZE_ALL
+	select ARCH_HAS_UBSAN_SANITIZE_ALL
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
_

Patches currently in -mm which might be from valentinrothberg@gmail.com are

powerpc-enable-ubsan-support.patch

