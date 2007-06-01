From: akpm@linux-foundation.org
Subject: - alpha-support-graphics-on-non-zero-pci-domains-fix.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:16:52 -0700
Message-ID: <200706010716.l517GpkV004915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbXFAHRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha-support-graphics-on-non-zero-pci-domains fix
has been removed from the -mm tree.  Its filename was
     alpha-support-graphics-on-non-zero-pci-domains-fix.patch

This patch was dropped because it was folded into alpha-support-graphics-on-non-zero-pci-domains.patch

------------------------------------------------------
Subject: alpha-support-graphics-on-non-zero-pci-domains fix
From: Andrew Morton <akpm@linux-foundation.org>

The runtime already did that.

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/console.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/kernel/console.c~alpha-support-graphics-on-non-zero-pci-domains-fix arch/alpha/kernel/console.c
--- a/arch/alpha/kernel/console.c~alpha-support-graphics-on-non-zero-pci-domains-fix
+++ a/arch/alpha/kernel/console.c
@@ -17,7 +17,7 @@
 
 #ifdef CONFIG_VGA_HOSE
 
-struct pci_controller *pci_vga_hose = NULL;
+struct pci_controller *pci_vga_hose;
 static struct resource alpha_vga = {
 	.name	= "alpha-vga+",
 	.start	= 0x3C0,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
potential-parse-error-in-ifdef.patch
potential-parse-error-in-ifdef-update.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
alpha-support-graphics-on-non-zero-pci-domains.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
