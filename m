From: akpm@linux-foundation.org
Subject: + cris-tlbh-should-include-linux-pagemaph.patch added to -mm tree
Date: Wed, 14 Nov 2007 08:40:37 -0800
Message-ID: <200711141640.lAEGebKN014956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760841AbXKNQlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 11:41:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRIS tlb.h should include linux/pagemap.h
has been added to the -mm tree.  Its filename is
     cris-tlbh-should-include-linux-pagemaph.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRIS tlb.h should include linux/pagemap.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Include linux/pagemap.h for release_pages and page_cache_release.

Fixes compilation error in arch/cris/mm/init.c when CONFIG_SWAP is unset.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/tlb.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-cris/tlb.h~cris-tlbh-should-include-linux-pagemaph include/asm-cris/tlb.h
--- a/include/asm-cris/tlb.h~cris-tlbh-should-include-linux-pagemaph
+++ a/include/asm-cris/tlb.h
@@ -1,6 +1,8 @@
 #ifndef _CRIS_TLB_H
 #define _CRIS_TLB_H
 
+#include <linux/pagemap.h>
+
 #include <asm/arch/tlb.h>
 
 /*
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

git-mtd.patch
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
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
cris-dont-include-bitopsh-in-posix_typesh.patch
crisv10-serial-driver-rewrite-take-three.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
crisv10-fix-timer-interrupt-parameters.patch
crisv10-improve-and-bugfix-fasttimer.patch
crisv32-add-cache-flush-operations.patch
cris-tlbh-should-include-linux-pagemaph.patch
