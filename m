From: akpm@linux-foundation.org
Subject: - unexport-pm_power_off_prepare.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:05 -0700
Message-ID: <200710190341.l9J3f5gp012770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966500AbXJSDz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     unexport pm_power_off_prepare
has been removed from the -mm tree.  Its filename was
     unexport-pm_power_off_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unexport pm_power_off_prepare
From: Adrian Bunk <bunk@stusta.de>

This patch removes the unused EXPORT_SYMBOL(pm_power_off_prepare).

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/sys.c~unexport-pm_power_off_prepare kernel/sys.c
--- a/kernel/sys.c~unexport-pm_power_off_prepare
+++ a/kernel/sys.c
@@ -105,7 +105,6 @@ EXPORT_SYMBOL(cad_pid);
  */
 
 void (*pm_power_off_prepare)(void);
-EXPORT_SYMBOL(pm_power_off_prepare);
 
 /*
  *	Notifier list for kernel code which wants to be called
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
git-parisc.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
