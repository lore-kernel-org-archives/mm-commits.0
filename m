From: akpm@linux-foundation.org
Subject: + cris-build-fixes-sys_crisc-needs-fsh.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:09:45 -0700
Message-ID: <200710302209.l9UM9jFg030342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbXJ3WJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris build fixes: sys_cris.c needs fs.h
has been added to the -mm tree.  Its filename is
     cris-build-fixes-sys_crisc-needs-fsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cris build fixes: sys_cris.c needs fs.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Include linux/fs.h, needed for do_pipe.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/sys_cris.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/kernel/sys_cris.c~cris-build-fixes-sys_crisc-needs-fsh arch/cris/kernel/sys_cris.c
--- a/arch/cris/kernel/sys_cris.c~cris-build-fixes-sys_crisc-needs-fsh
+++ a/arch/cris/kernel/sys_cris.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/sem.h>
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
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
