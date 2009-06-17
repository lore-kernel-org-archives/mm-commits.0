From: akpm@linux-foundation.org
Subject: [folded] edac-add-cpc925-memory-controller-driver-cleanup.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:53:56 -0700
Message-ID: <200906172253.n5HMrvwL013680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbZFQWyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org, qingtao.cao@windriver.com, mm-commits@vger.kernel.org


The patch titled
     edac-add-cpc925-memory-controller-driver-cleanup
has been removed from the -mm tree.  Its filename was
     edac-add-cpc925-memory-controller-driver-cleanup.patch

This patch was dropped because it was folded into edac-add-cpc925-memory-controller-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac-add-cpc925-memory-controller-driver-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

restrict the scope.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Harry Ciao <qingtao.cao@windriver.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/cpc925_edac.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/edac/cpc925_edac.c~edac-add-cpc925-memory-controller-driver-cleanup drivers/edac/cpc925_edac.c
--- a/drivers/edac/cpc925_edac.c~edac-add-cpc925-memory-controller-driver-cleanup
+++ a/drivers/edac/cpc925_edac.c
@@ -291,9 +291,6 @@ struct cpc925_dev_info {
 	void (*check)(struct edac_device_ctl_info *edac_dev);
 };
 
-
-static int edac_mc_idx;
-
 /* Get total memory size from Open Firmware DTB */
 static void get_total_mem(struct cpc925_mc_pdata *pdata)
 {
@@ -866,6 +863,7 @@ static int cpc925_mc_get_channels(void _
 
 static int __devinit cpc925_probe(struct platform_device *pdev)
 {
+	static int edac_mc_idx;
 	struct mem_ctl_info *mci;
 	void __iomem *vbase;
 	struct cpc925_mc_pdata *pdata;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

