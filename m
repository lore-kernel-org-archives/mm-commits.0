From: akpm@linux-foundation.org
Subject: [folded] edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:55:25 -0700
Message-ID: <200906172255.n5HMtPL3015028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbZFQWzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, geunsik.lim@samsung.com, leemgs1@gmail.com, mm-commits@vger.kernel.org


The patch titled
     edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix
has been removed from the -mm tree.  Its filename was
     edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch

This patch was dropped because it was folded into edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: GeunSik Lim <geunsik.lim@samsung.com>
Cc: GeunSik Lim <leemgs1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/Kconfig~edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix
+++ a/drivers/edac/Kconfig
@@ -5,7 +5,7 @@
 #
 
 menuconfig EDAC
-	bool "EDAC(Error Detection And Correction) reporting"
+	bool "EDAC (Error Detection And Correction) reporting"
 	depends on HAS_IOMEM
 	depends on X86 || PPC
 	help
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
edac-add-edac_device_alloc_index.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

