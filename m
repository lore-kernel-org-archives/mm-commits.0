From: akpm@linux-foundation.org
Subject: + init-mainc-remove-prototype-for-softirq_init.patch added to -mm tree
Date: Mon, 04 Nov 2013 13:17:17 -0800
Message-ID: <52780edd.DJHdadbm3Fxeaael%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3KDVRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 16:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + init-mainc-remove-prototype-for-softirq_init.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 13:17:17 -0800


The patch titled
     Subject: init/main.c: remove prototype for softirq_init()
has been added to the -mm tree.  Its filename is
     init-mainc-remove-prototype-for-softirq_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-remove-prototype-for-softirq_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-remove-prototype-for-softirq_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: init/main.c: remove prototype for softirq_init()

It's already available in <linux/interrupt.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN init/main.c~init-mainc-remove-prototype-for-softirq_init init/main.c
--- a/init/main.c~init-mainc-remove-prototype-for-softirq_init
+++ a/init/main.c
@@ -124,7 +124,6 @@ EXPORT_SYMBOL(system_state);
 extern void time_init(void);
 /* Default late time init is NULL. archs can override this later. */
 void (*__initdata late_time_init)(void);
-extern void softirq_init(void);
 
 /* Untouched command line saved by arch-specific code. */
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
_

Patches currently in -mm which might be from geert@linux-m68k.org are

genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
block-do-not-call-sector_div-with-a-64-bit-divisor.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
kernel-sysc-remove-obsolete-include-linux-kexech.patch
init-mainc-remove-prototype-for-softirq_init.patch
inith-document-the-existence-of-__initconst.patch
init-make-init-failures-more-explicit.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
m68k-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail-fix.patch
m68k-handle-pgtable_page_ctor-fail-fix-fix.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch

