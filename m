From: akpm@linux-foundation.org
Subject: - block-remove-excess-kernel-doc.patch removed from -mm tree
Date: Tue, 25 Nov 2008 11:57:54 -0800
Message-ID: <200811251957.mAPJvs6O029384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbYKYT6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 14:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     block: remove excess kernel-doc
has been removed from the -mm tree.  Its filename was
     block-remove-excess-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: remove excess kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Delete excess kernel-doc notation in block/ subdirectory:

Warning(linux-2.6.27-git10//block/blk-tag.c:164): Excess function parameter or struct member 'tags' description in 'blk_init_tags'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-tag.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN block/blk-tag.c~block-remove-excess-kernel-doc block/blk-tag.c
--- a/block/blk-tag.c~block-remove-excess-kernel-doc
+++ a/block/blk-tag.c
@@ -158,7 +158,6 @@ fail:
 /**
  * blk_init_tags - initialize the tag info for an external tag map
  * @depth:	the maximum queue depth supported
- * @tags: the tag to use
  **/
 struct blk_queue_tag *blk_init_tags(int depth)
 {
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

