From: akpm@linux-foundation.org
Subject: - arch-i386-kernel-pci-dmac-remove-duplicate-include.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:36:04 -0700
Message-ID: <200707230936.l6N9a4Qh016611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758216AbXGWJpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muneda.takahiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     arch/i386/kernel/pci-dma.c: remove duplicate include
has been removed from the -mm tree.  Its filename was
     arch-i386-kernel-pci-dmac-remove-duplicate-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/i386/kernel/pci-dma.c: remove duplicate include
From: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>

Remove duplicate include arch/i386/kernel/pci-dma.c

Signed-off-by: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/pci-dma.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN arch/i386/kernel/pci-dma.c~arch-i386-kernel-pci-dmac-remove-duplicate-include arch/i386/kernel/pci-dma.c
--- a/arch/i386/kernel/pci-dma.c~arch-i386-kernel-pci-dmac-remove-duplicate-include
+++ a/arch/i386/kernel/pci-dma.c
@@ -12,7 +12,6 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <asm/io.h>
 
 struct dma_coherent_mem {
_

Patches currently in -mm which might be from muneda.takahiro@jp.fujitsu.com are
