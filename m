From: akpm@linux-foundation.org
Subject: - libata-add-missing-kernel-doc.patch removed from -mm tree
Date: Tue, 28 Oct 2008 12:07:01 -0700
Message-ID: <200810281907.m9SJ71no023722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbYJ1THj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 15:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     libata: add missing kernel-doc
has been removed from the -mm tree.  Its filename was
     libata-add-missing-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: add missing kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix libata missing kernel-doc:

Warning(lin2628-rc2//drivers/ata/libata-core.c:4562): No description found for parameter 'tag'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/libata-core.c~libata-add-missing-kernel-doc drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-missing-kernel-doc
+++ a/drivers/ata/libata-core.c
@@ -4553,6 +4553,7 @@ void swap_buf_le16(u16 *buf, unsigned in
 /**
  *	ata_qc_new_init - Request an available ATA command, and initialize it
  *	@dev: Device from whom we request an available command structure
+ *	@tag: command tag
  *
  *	LOCKING:
  *	None.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
mm-fix-kernel-doc-function-notation.patch
fs-remove-excess-kernel-doc.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

