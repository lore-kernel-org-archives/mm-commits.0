From: akpm@linux-foundation.org
Subject: - fusion-remove-excess-kernel-doc-notation.patch removed from -mm tree
Date: Tue, 25 Nov 2008 11:57:48 -0800
Message-ID: <200811251957.mAPJvmn2029296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbYKYT5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 14:57:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Eric.Moore@lsil.com, mm-commits@vger.kernel.org


The patch titled
     fusion: remove excess kernel-doc notation
has been removed from the -mm tree.  Its filename was
     fusion-remove-excess-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fusion: remove excess kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove excess kernel-doc function parameter notation:

Warning(drivers/message/fusion/mptbase.c:964): Excess function parameter or struct member 'handle' description in 'mpt_free_msg_frame'
Warning(drivers/message/fusion/mptbase.c:5434): Excess function parameter or struct member 'portnum' description in 'mpt_findImVolumes'
Warning(drivers/message/fusion/mptbase.c:6949): Excess function parameter or struct member 'mr' description in 'mpt_spi_log_info'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~fusion-remove-excess-kernel-doc-notation drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~fusion-remove-excess-kernel-doc-notation
+++ a/drivers/message/fusion/mptbase.c
@@ -952,7 +952,6 @@ mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_free_msg_frame - Place MPT request frame back on FreeQ.
- *	@handle: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@mf: Pointer to MPT request frame
  *
@@ -5422,7 +5421,6 @@ mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc,
 /**
  *	mpt_findImVolumes - Identify IDs of hidden disks and RAID Volumes
  *	@ioc: Pointer to a Adapter Strucutre
- *	@portnum: IOC port number
  *
  *	Return:
  *	0 on success
@@ -6939,7 +6937,6 @@ mpt_fc_log_info(MPT_ADAPTER *ioc, u32 lo
 /**
  *	mpt_spi_log_info - Log information returned from SCSI Parallel IOC.
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@mr: Pointer to MPT reply frame
  *	@log_info: U32 LogInfo word from the IOC
  *
  *	Refer to lsi/sp_log.h.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
kernel-doc-handle-varargs-cleanly.patch
ntfs-dont-fool-kernel-doc.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
profile-likely-unlikely-macros.patch

