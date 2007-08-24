From: akpm@linux-foundation.org
Subject: - m68k-asm-pageh-needs-linux-compilerh.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:01 -0700
Message-ID: <200708242056.l7OKu1Ro014002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762199AbXHXVIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: <asm/page.h> needs <linux/compiler.h>
has been removed from the -mm tree.  Its filename was
     m68k-asm-pageh-needs-linux-compilerh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: <asm/page.h> needs <linux/compiler.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k: <asm/page.h> needs <linux/compiler.h> because of __attribute_const__

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/page.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/asm-m68k/page.h~m68k-asm-pageh-needs-linux-compilerh include/asm-m68k/page.h
--- a/include/asm-m68k/page.h~m68k-asm-pageh-needs-linux-compilerh
+++ a/include/asm-m68k/page.h
@@ -27,6 +27,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/compiler.h>
+
 #include <asm/module.h>
 
 #define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
