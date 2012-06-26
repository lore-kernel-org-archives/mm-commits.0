From: akpm@linux-foundation.org
Subject: + h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch added to -mm tree
Date: Tue, 26 Jun 2012 16:50:24 -0700
Message-ID: <20120626235025.3A278A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2FZXu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 19:50:26 -0400
Received: by vcbfl13 with SMTP id fl13so55018vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 16:50:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, tony@bakeyournoodle.com, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300/pgtable: add missing #include <asm-generic/pgtable.h>
has been added to the -mm tree.  Its filename is
     h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch

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
Subject: h8300/pgtable: add missing #include <asm-generic/pgtable.h>

kernel/sched/core.c: In function 'context_switch':
kernel/sched/core.c:2061:2: error: implicit declaration of function 'arch_start_context_switch' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/h8300/include/asm/pgtable.h~h8300-pgtable-add-missing-include-asm-generic-pgtableh arch/h8300/include/asm/pgtable.h
--- a/arch/h8300/include/asm/pgtable.h~h8300-pgtable-add-missing-include-asm-generic-pgtableh
+++ a/arch/h8300/include/asm/pgtable.h
@@ -70,4 +70,7 @@ extern int is_in_rom(unsigned long);
 #define	VMALLOC_END	0xffffffff
 
 #define arch_enter_lazy_cpu_mode()    do {} while (0)
+
+#include <asm-generic/pgtable.h>
+
 #endif /* _H8300_PGTABLE_H */
_
Subject: Subject: h8300/pgtable: add missing #include <asm-generic/pgtable.h>

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch
h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch
h8300-signal-fix-typo-statis.patch
h8300-time-add-missing-include-asm-irq_regsh.patch
h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch
h8300-uaccess-add-mising-__clear_user.patch

