From: akpm@linux-foundation.org
Subject: [merged] mn10300-kernel-trapsc-needs-linux-exporth.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:22 -0700
Message-ID: <20120712193622.AF0061E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2GLTgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:23 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so16661vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: kernel/traps.c needs <linux/export.h>
has been removed from the -mm tree.  Its filename was
     mn10300-kernel-trapsc-needs-linux-exporth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

