From: akpm@linux-foundation.org
Subject: + arch-i386-kernel-pci-dmac-remove-duplicate-include.patch added to -mm tree
Date: Fri, 20 Jul 2007 16:55:48 -0700
Message-ID: <200707202355.l6KNtmgI023009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759508AbXGTXz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 19:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muneda.takahiro@jp.fujitsu.com


The patch titled
     arch/i386/kernel/pci-dma.c: remove duplicate include
has been added to the -mm tree.  Its filename is
     arch-i386-kernel-pci-dmac-remove-duplicate-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

arch-i386-kernel-pci-dmac-remove-duplicate-include.patch
