From: akpm@linux-foundation.org
Subject: - e100-fix-printk-format-warning.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:52:03 -0700
Message-ID: <200807112352.m6BNq3Hf011100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756588AbYGKXwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dwmw2@infradead.org, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e100: fix printk format warning
has been removed from the -mm tree.  Its filename was
     e100-fix-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e100: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/net/e100.c:1145: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/e100.c~e100-fix-printk-format-warning drivers/net/e100.c
--- a/drivers/net/e100.c~e100-fix-printk-format-warning
+++ a/drivers/net/e100.c
@@ -1142,7 +1142,7 @@ static const struct firmware *e100_reque
 	/* Firmware should be precisely UCODE_SIZE (words) plus three bytes
 	   indicating the offsets for BUNDLESMALL, BUNDLEMAX, INTDELAY */
 	if (fw->size != UCODE_SIZE * 4 + 3) {
-		DPRINTK(PROBE,ERR, "Firmware \"%s\" has wrong size %d\n",
+		DPRINTK(PROBE,ERR, "Firmware \"%s\" has wrong size %zu\n",
 			fw_name, fw->size);
 		release_firmware(fw);
 		return ERR_PTR(-EINVAL);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
bluetooth-hci_bcsp-fix-bitrev-kconfig.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
lkdtm-fix-for-config_scsi=n.patch
compat_ioctl-handle-block=n-scsi=n.patch
git-unionfs.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

