From: akpm@linux-foundation.org
Subject: [merged] init-mainc-remove-prototype-for-softirq_init.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:12 -0800
Message-ID: <5283e3ac.Lv36jF/Smr/3AwoG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3KMUkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: [merged] init-mainc-remove-prototype-for-softirq_init.patch removed from -mm tree
To: geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:12 -0800


The patch titled
     Subject: init/main.c: remove prototype for softirq_init()
has been removed from the -mm tree.  Its filename was
     init-mainc-remove-prototype-for-softirq_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
m68k-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail-fix.patch
m68k-handle-pgtable_page_ctor-fail-fix-fix.patch

