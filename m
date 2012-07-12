From: akpm@linux-foundation.org
Subject: [merged] mn10300-mm-dma-allocc-needs-linux-exporth.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:25 -0700
Message-ID: <20120712193625.8FB32100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51552 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2GLTg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:26 -0400
Received: by yhl10 with SMTP id 10so268264yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: mm/dma-alloc.c needs <linux/export.h>
has been removed from the -mm tree.  Its filename was
     mn10300-mm-dma-allocc-needs-linux-exporth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mn10300: mm/dma-alloc.c needs <linux/export.h>

arch/mn10300/mm/dma-alloc.c: At top level:
arch/mn10300/mm/dma-alloc.c:63:1: warning: data definition has no type or storage class [enabled by default]
arch/mn10300/mm/dma-alloc.c:63:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
arch/mn10300/mm/dma-alloc.c:63:1: warning: parameter names (without types) in function declaration [enabled by default]
arch/mn10300/mm/dma-alloc.c:75:1: warning: data definition has no type or storage class [enabled by default]
arch/mn10300/mm/dma-alloc.c:75:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
arch/mn10300/mm/dma-alloc.c:75:1: warning: parameter names (without types) in function declaration [enabled by default]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/mm/dma-alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mn10300/mm/dma-alloc.c~mn10300-mm-dma-allocc-needs-linux-exporth arch/mn10300/mm/dma-alloc.c
--- a/arch/mn10300/mm/dma-alloc.c~mn10300-mm-dma-allocc-needs-linux-exporth
+++ a/arch/mn10300/mm/dma-alloc.c
@@ -15,6 +15,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/gfp.h>
+#include <linux/export.h>
 #include <asm/io.h>
 
 static unsigned long pci_sram_allocated = 0xbc000000;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

