From: akpm@linux-foundation.org
Subject: + mn10300-kernel-trapsc-needs-linux-exporth.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:17:08 -0700
Message-ID: <20120620221708.683A7A01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46880 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab2FTWRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:17:09 -0400
Received: by ghbz15 with SMTP id z15so763263ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:17:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com


The patch titled
     Subject: mn10300: kernel/traps.c needs <linux/export.h>
has been added to the -mm tree.  Its filename is
     mn10300-kernel-trapsc-needs-linux-exporth.patch

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
Subject: mn10300: kernel/traps.c needs <linux/export.h>

arch/mn10300/kernel/traps.c:304:1: warning: data definition has no type or storage class [enabled by default]
arch/mn10300/kernel/traps.c:304:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
arch/mn10300/kernel/traps.c:304:1: warning: parameter names (without types) in function declaration [enabled by default]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mn10300/kernel/traps.c~mn10300-kernel-trapsc-needs-linux-exporth arch/mn10300/kernel/traps.c
--- a/arch/mn10300/kernel/traps.c~mn10300-kernel-trapsc-needs-linux-exporth
+++ a/arch/mn10300/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <linux/kdebug.h>
 #include <linux/bug.h>
 #include <linux/irq.h>
+#include <linux/export.h>
 #include <asm/processor.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
_
Subject: Subject: mn10300: kernel/traps.c needs <linux/export.h>

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch
xtensa-use-test-e-instead-of-bashism-test-a.patch
xtensa-use-the-declarations-provided-by-asm-sectionsh.patch
h8300-fix-use-of-extinct-_sbss-and-_ebss.patch
h8300-use-the-declarations-provided-by-asm-sectionsh.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch

