From: akpm@linux-foundation.org
Subject: [merged] h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:49 -0700
Message-ID: <20120712193650.10E345C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:37005 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2GLTgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:52 -0400
Received: by lbbgp10 with SMTP id gp10so162745lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, tony@bakeyournoodle.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300/pgtable: add missing #include <asm-generic/pgtable.h>
has been removed from the -mm tree.  Its filename was
     h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

