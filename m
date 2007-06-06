From: akpm@linux-foundation.org
Subject: + drivers-edac-add-info-kconfig.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:51:29 -0700
Message-ID: <200706060151.l561pTNj007527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934480AbXFFB4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers-edac: add info kconfig
has been added to the -mm tree.  Its filename is
     drivers-edac-add-info-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: add info kconfig
From: Douglas Thompson <dougthompson@xmission.com>

Kconfig - modified the help of EDAC

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/edac/Kconfig~drivers-edac-add-info-kconfig drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~drivers-edac-add-info-kconfig
+++ a/drivers/edac/Kconfig
@@ -11,8 +11,9 @@ menuconfig EDAC
 	help
 	  EDAC is designed to report errors in the core system.
 	  These are low-level errors that are reported in the CPU or
-	  supporting chipset: memory errors, cache errors, PCI errors,
-	  thermal throttling, etc..  If unsure, select 'Y'.
+	  supporting chipset or other subsystems:
+	  memory errors, cache errors, PCI errors, thermal throttling, etc..
+	  If unsure, select 'Y'.
 
 	  If this code is reporting problems on your system, please
 	  see the EDAC project web pages for more information at:
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-remove-depends-on-x86.patch
drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
