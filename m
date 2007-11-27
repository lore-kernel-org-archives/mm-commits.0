From: akpm@linux-foundation.org
Subject: + vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script.patch added to -mm tree
Date: Tue, 27 Nov 2007 00:31:35 -0800
Message-ID: <200711270831.lAR8VZhp002701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbXK0Ick (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 03:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     vmlinux_32.lds.S: remove repeated comment from the x86-32 linker script
has been added to the -mm tree.  Its filename is
     vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

revert-keyspan-init-termios-properly.patch
vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script.patch
