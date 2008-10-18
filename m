From: akpm@linux-foundation.org
Subject: - kernel-dmac-remove-a-cvs-keyword.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:10 -0700
Message-ID: <200810182311.m9INBAPF027682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbYJRXLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/dma.c: remove a CVS keyword
has been removed from the -mm tree.  Its filename was
     kernel-dmac-remove-a-cvs-keyword.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/dma.c: remove a CVS keyword
From: Adrian Bunk <bunk@kernel.org>

Remove a CVS keyword that wasn't updated for a long time from a comment.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/dma.c~kernel-dmac-remove-a-cvs-keyword kernel/dma.c
--- a/kernel/dma.c~kernel-dmac-remove-a-cvs-keyword
+++ a/kernel/dma.c
@@ -1,4 +1,4 @@
-/* $Id: dma.c,v 1.7 1994/12/28 03:35:33 root Exp root $
+/*
  * linux/kernel/dma.c: A DMA channel allocator. Inspired by linux/kernel/irq.c.
  *
  * Written by Hennus Bergman, 1992.
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch

