From: akpm@linux-foundation.org
Subject: - uwb-fix-kconfig-causing-undefined-references.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:23 -0700
Message-ID: <200806232102.m5NL2N3A016070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759589AbYFWVCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     uwb: fix Kconfig causing undefined references
has been removed from the -mm tree.  Its filename was
     uwb-fix-kconfig-causing-undefined-references.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uwb: fix Kconfig causing undefined references
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix UWB kconfig so that function reference problems are not generated.

next-20080430/drivers/uwb/whc-rc.c:478: undefined reference to `hwarc_filter_event'
next-20080430/drivers/uwb/whc-rc.c:478: undefined reference to `hwarc_filter_cmd'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/uwb/Kconfig~uwb-fix-kconfig-causing-undefined-references drivers/uwb/Kconfig
--- a/drivers/uwb/Kconfig~uwb-fix-kconfig-causing-undefined-references
+++ a/drivers/uwb/Kconfig
@@ -44,6 +44,7 @@ config UWB_HWA
 config UWB_WHCI
         tristate "UWB Radio Control driver for WHCI-compliant cards"
         depends on PCI
+	depends on UWB_HWA
         help
           This driver enables the radio controller for WHCI cards.
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
git-unionfs.patch
audit-fix-kernel-doc-parameter-notation.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch

