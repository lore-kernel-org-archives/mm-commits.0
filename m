From: akpm@linux-foundation.org
Subject: + mn10300-kernel-internalh-needs-linux-irqreturnh.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:17:06 -0700
Message-ID: <20120620221706.3B5DDA01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58358 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230Ab2FTWRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:17:08 -0400
Received: by bkty5 with SMTP id y5so443557bkt.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:17:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com


The patch titled
     Subject: mn10300: kernel/internal.h needs <linux/irqreturn.h>
has been added to the -mm tree.  Its filename is
     mn10300-kernel-internalh-needs-linux-irqreturnh.patch

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
Subject: mn10300: kernel/internal.h needs <linux/irqreturn.h>

In file included from arch/mn10300/kernel/csrc-mn10300.c:14:0:
arch/mn10300/kernel/internal.h:42:1: error: unknown type name 'irqreturn_t'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/internal.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/mn10300/kernel/internal.h~mn10300-kernel-internalh-needs-linux-irqreturnh arch/mn10300/kernel/internal.h
--- a/arch/mn10300/kernel/internal.h~mn10300-kernel-internalh-needs-linux-irqreturnh
+++ a/arch/mn10300/kernel/internal.h
@@ -9,6 +9,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/irqreturn.h>
+
 struct clocksource;
 struct clock_event_device;
 
_
Subject: Subject: mn10300: kernel/internal.h needs <linux/irqreturn.h>

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

