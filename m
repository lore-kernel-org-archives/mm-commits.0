From: akpm@linux-foundation.org
Subject: - vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:23:43 -0800
Message-ID: <200712010023.lB10NhDE032008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757631AbXLAA1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     vmlinux_32.lds.S: remove repeated comment from the x86-32 linker script
has been removed from the -mm tree.  Its filename was
     vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vmlinux_32.lds.S: remove repeated comment from the x86-32 linker script
From: Borislav Petkov <bbpetkov@yahoo.de>

Remove repeated comment from the linker script for the x86-32 target.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux_32.lds.S |    6 ------
 1 file changed, 6 deletions(-)

diff -puN arch/x86/kernel/vmlinux_32.lds.S~vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script arch/x86/kernel/vmlinux_32.lds.S
--- a/arch/x86/kernel/vmlinux_32.lds.S~vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script
+++ a/arch/x86/kernel/vmlinux_32.lds.S
@@ -8,12 +8,6 @@
  * put it inside the section definition.
  */
 
-/* Don't define absolute symbols until and unless you know that symbol
- * value is should remain constant even if kernel image is relocated
- * at run time. Absolute symbols are not relocated. If symbol value should
- * change if kernel is relocated, make the symbol section relative and
- * put it inside the section definition.
- */
 #define LOAD_OFFSET __PAGE_OFFSET
 
 #include <asm-generic/vmlinux.lds.h>
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
git-x86.patch
