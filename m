From: akpm@linux-foundation.org
Subject: + arch-mips-remove-duplicate-includes.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:35:50 -0800
Message-ID: <200711060235.lA62ZosS032024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613AbXKFCgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:36:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: woodzy@gmail.com, ralf@linux-mips.org


The patch titled
     arch/mips: remove duplicate includes
has been added to the -mm tree.  Its filename is
     arch-mips-remove-duplicate-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/mips: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/rtlx.c |    1 -
 arch/mips/kernel/vpe.c  |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/mips/kernel/rtlx.c~arch-mips-remove-duplicate-includes arch/mips/kernel/rtlx.c
--- a/arch/mips/kernel/rtlx.c~arch-mips-remove-duplicate-includes
+++ a/arch/mips/kernel/rtlx.c
@@ -40,7 +40,6 @@
 #include <asm/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/mips_mt.h>
 #include <asm/system.h>
 #include <asm/vpe.h>
 #include <asm/rtlx.h>
diff -puN arch/mips/kernel/vpe.c~arch-mips-remove-duplicate-includes arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c~arch-mips-remove-duplicate-includes
+++ a/arch/mips/kernel/vpe.c
@@ -53,7 +53,6 @@
 #include <asm/system.h>
 #include <asm/vpe.h>
 #include <asm/kspd.h>
-#include <asm/mips_mt.h>
 
 typedef void *vpe_handle;
 
_

Patches currently in -mm which might be from woodzy@gmail.com are

arch-alpha-removed-duplicate-includes.patch
arch-arm-removed-duplicate-includes.patch
arch-ia64-remove-duplicate-includes.patch
arch-mips-remove-duplicate-includes.patch
arch-parisc-remove-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
arch-sparc-remove-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch
