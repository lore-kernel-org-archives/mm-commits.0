From: akpm@linux-foundation.org
Subject: + fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:51:56 -0700
Message-ID: <200708162051.l7GKpuPs006097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756061AbXHPUwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bzolnier@gmail.com, lenb@kernel.org, shaohua.li@intel.com


The patch titled
     fix ide-ide-hook-acpi-psx-method-to-ide-power-on-off
has been added to the -mm tree.  Its filename is
     fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix ide-ide-hook-acpi-psx-method-to-ide-power-on-off
From: Adrian Bunk <bunk@kernel.org>

This patch removes the unused EXPORT_SYMBOL_GPL(ide_acpi_set_state)

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-acpi.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/ide/ide-acpi.c~fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off drivers/ide/ide-acpi.c
--- a/drivers/ide/ide-acpi.c~fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off
+++ a/drivers/ide/ide-acpi.c
@@ -649,7 +649,6 @@ void ide_acpi_set_state(ide_hwif_t *hwif
 	if (!on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3);
 }
-EXPORT_SYMBOL_GPL(ide_acpi_set_state);
 
 /**
  * ide_acpi_init - initialize the ACPI link for an IDE interface
_

Patches currently in -mm which might be from bunk@kernel.org are

alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
