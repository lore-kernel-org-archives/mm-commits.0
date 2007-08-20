From: akpm@linux-foundation.org
Subject: - alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch removed from -mm tree
Date: Mon, 20 Aug 2007 11:54:36 -0700
Message-ID: <200708201854.l7KIsa7x017537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755216AbXHTSyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 14:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     make drivers/ata/libata-scsi.c:ata_scsi_link_pm_policy() static
has been removed from the -mm tree.  Its filename was
     alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: make drivers/ata/libata-scsi.c:ata_scsi_link_pm_policy() static
From: Adrian Bunk <bunk@kernel.org>

ata_scsi_link_pm_policy() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-scsi.c~alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static
+++ a/drivers/ata/libata-scsi.c
@@ -121,7 +121,7 @@ static const struct {
 	{ MEDIUM_POWER, "medium_power" },
 };
 
-const char *ata_scsi_link_pm_policy(enum link_pm policy)
+static const char *ata_scsi_link_pm_policy(enum link_pm policy)
 {
 	int i;
 	char *name = NULL;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
if-0-v9fs_fid_lookup_remove.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
