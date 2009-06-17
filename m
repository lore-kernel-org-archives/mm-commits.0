From: akpm@linux-foundation.org
Subject: [folded] gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:44:58 -0700
Message-ID: <200906172244.n5HMiwf7005294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733AbZFQWo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:44:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, ncase@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch

This patch was dropped because it was folded into gpio-pca953x-get-platform_data-from-openfirmware.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#82: FILE: drivers/gpio/pca953x.c:239:
+	if (val) {
+		pdata->invert = *val;
+	}

total: 0 errors, 1 warnings, 119 lines checked

./patches/gpio-pca953x-get-platform_data-from-openfirmware.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Nate Case <ncase@xes-inc.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes
+++ a/drivers/gpio/pca953x.c
@@ -236,9 +236,8 @@ pca953x_get_alt_pdata(struct i2c_client 
 	}
 
 	val = of_get_property(node, "polarity", NULL);
-	if (val) {
+	if (val)
 		pdata->invert = *val;
-	}
 
 	return pdata;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

