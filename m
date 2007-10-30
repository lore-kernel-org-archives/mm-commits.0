From: akpm@linux-foundation.org
Subject: + cris-build-fixes-setupc-needs-paramh.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:13:02 -0700
Message-ID: <200710302213.l9UMD2ch030505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059AbXJ3WNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris build fixes: setup.c needs param.h
has been added to the -mm tree.  Its filename is
     cris-build-fixes-setupc-needs-paramh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cris build fixes: setup.c needs param.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Include linux/param.h for HZ.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/arch-v10/kernel/setup.c~cris-build-fixes-setupc-needs-paramh arch/cris/arch-v10/kernel/setup.c
--- a/arch/cris/arch-v10/kernel/setup.c~cris-build-fixes-setupc-needs-paramh
+++ a/arch/cris/arch-v10/kernel/setup.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
+#include <linux/param.h>
 
 #ifdef CONFIG_PROC_FS
 #define HAS_FPU		0x0001
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
