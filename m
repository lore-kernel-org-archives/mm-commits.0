From: akpm@linux-foundation.org
Subject: - mtd-add-module-license-to-mtdbdi.patch removed from -mm tree
Date: Fri, 14 Sep 2007 15:18:24 -0700
Message-ID: <200709142218.l8EMIPxK027043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbXINWSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 18:18:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: add module license to mtdbdi
has been removed from the -mm tree.  Its filename was
     mtd-add-module-license-to-mtdbdi.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mtd: add module license to mtdbdi
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This seems to be a known issue [1] about Photron PNC-2000 module called
pnc2000.  To reproduce this just 'modprobe pnc2000'.  The patch attached at
least makes the kernel to be not tainted when mtdbdi gets loaded.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdbdi.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/mtd/mtdbdi.c~mtd-add-module-license-to-mtdbdi drivers/mtd/mtdbdi.c
--- a/drivers/mtd/mtdbdi.c~mtd-add-module-license-to-mtdbdi
+++ a/drivers/mtd/mtdbdi.c
@@ -46,3 +46,5 @@ struct backing_dev_info mtd_bdi_rw_mappa
 			   BDI_CAP_WRITE_MAP),
 };
 EXPORT_SYMBOL_GPL(mtd_bdi_rw_mappable);
+
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
arm-unbalanced-parenthesis-fix.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
git-mmc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
git-v9fs.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
