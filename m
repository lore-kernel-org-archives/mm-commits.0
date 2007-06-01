From: akpm@linux-foundation.org
Subject: - alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:16:58 -0700
Message-ID: <200706010716.l517GvwI004918@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095AbXFAHRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:17:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha-support-graphics-on-non-zero-pci-domains-fix-2
has been removed from the -mm tree.  Its filename was
     alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch

This patch was dropped because it was folded into alpha-support-graphics-on-non-zero-pci-domains.patch

------------------------------------------------------
Subject: alpha-support-graphics-on-non-zero-pci-domains-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

In file included from arch/alpha/kernel/process.c:42:
arch/alpha/kernel/proto.h: In function 'locate_and_init_vga':
arch/alpha/kernel/proto.h:117: error: parameter name omitted

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/proto.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/kernel/proto.h~alpha-support-graphics-on-non-zero-pci-domains-fix-2 arch/alpha/kernel/proto.h
--- a/arch/alpha/kernel/proto.h~alpha-support-graphics-on-non-zero-pci-domains-fix-2
+++ a/arch/alpha/kernel/proto.h
@@ -114,7 +114,7 @@ extern void find_console_vga_hose(void);
 extern void locate_and_init_vga(void *(*)(void *, void *));
 #else
 static inline void find_console_vga_hose(void) { }
-static inline void locate_and_init_vga(void *(*)(void *, void *)) { }
+static inline void locate_and_init_vga(void *(*sel_func)(void *, void *)) { }
 #endif
 
 /* setup.c */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
potential-parse-error-in-ifdef.patch
potential-parse-error-in-ifdef-update.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
alpha-support-graphics-on-non-zero-pci-domains.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
