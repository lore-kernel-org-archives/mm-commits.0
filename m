From: akpm@linux-foundation.org
Subject: - powerpc-rtas-msi-support-fix.patch removed from -mm tree
Date: Fri, 16 Feb 2007 01:37:22 -0800
Message-ID: <200702160937.l1G9bMHa026336@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36312 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966264AbXBPJhY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 04:37:24 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1G9bNhB018467
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 16 Feb 2007 01:37:23 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     powerpc-rtas-msi-support-fix
has been removed from the -mm tree.  Its filename was
     powerpc-rtas-msi-support-fix.patch

This patch was dropped because it was folded into powerpc-rtas-msi-support.patch

------------------------------------------------------
Subject: powerpc-rtas-msi-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/powerpc/platforms/pseries/setup.c~powerpc-rtas-msi-support-fix arch/powerpc/platforms/pseries/setup.c
--- a/arch/powerpc/platforms/pseries/setup.c~powerpc-rtas-msi-support-fix
+++ a/arch/powerpc/platforms/pseries/setup.c
@@ -64,6 +64,7 @@
 #include <asm/i8259.h>
 #include <asm/udbg.h>
 #include <asm/smp.h>
+#include <asm/msi.h>
 #include <asm/firmware.h>
 
 #include "plpar_wrappers.h"
@@ -237,6 +238,7 @@ static void __init pseries_discover_pic(
 			ppc_md.init_IRQ       = xics_init_IRQ;
 			setup_kexec_cpu_down_xics();
 			smp_init_pseries_xics();
+			msi_rtas_init();
 			return;
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
git-powerpc.patch
powerpc-rtas-msi-support.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
git-dvb.patch
git-input.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
