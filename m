From: akpm@linux-foundation.org
Subject: - lib-ioremapc-should-include-linux-ioh.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:43 -0700
Message-ID: <200710180654.l9I6shkx030545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761259AbXJRHkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:40:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     lib/ioremap.c should #include <linux/io.h>
has been removed from the -mm tree.  Its filename was
     lib-ioremapc-should-include-linux-ioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib/ioremap.c should #include <linux/io.h>
From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for its global
functions (in this case ioremap_page_range()).

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ioremap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/ioremap.c~lib-ioremapc-should-include-linux-ioh lib/ioremap.c
--- a/lib/ioremap.c~lib-ioremapc-should-include-linux-ioh
+++ a/lib/ioremap.c
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/io.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
unexport-pm_power_off_prepare.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
