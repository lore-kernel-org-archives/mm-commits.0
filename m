From: akpm@linux-foundation.org
Subject: [merged] mips-vpe-remove-leftover-unlock_kernel.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:54:38 -0800
Message-ID: <200911091954.nA9JscDS021968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbZKITyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:54:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkacur@redhat.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: vpe: remove unneeded smp_lock.h include
has been removed from the -mm tree.  Its filename was
     mips-vpe-remove-leftover-unlock_kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: vpe: remove unneeded smp_lock.h include
From: John Kacur <jkacur@redhat.com>

This file was recently de-BLKised.

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/vpe.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/mips/kernel/vpe.c~mips-vpe-remove-leftover-unlock_kernel arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c~mips-vpe-remove-leftover-unlock_kernel
+++ a/arch/mips/kernel/vpe.c
@@ -38,7 +38,6 @@
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/moduleloader.h>
 #include <linux/interrupt.h>
_

Patches currently in -mm which might be from jkacur@redhat.com are

linux-next.patch
efirtc-explicitly-set-llseek-to-no_llseek.patch

