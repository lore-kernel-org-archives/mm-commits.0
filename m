From: akpm@linux-foundation.org
Subject: - dev_set_name-fix-missing-kernel-doc.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:50 -0700
Message-ID: <200806122036.m5CKaodl005368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755866AbYFLUhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     dev_set_name: fix missing kernel-doc
has been removed from the -mm tree.  Its filename was
     dev_set_name-fix-missing-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dev_set_name: fix missing kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc for new dev_set_name() function:

Warning(lin2626-rc5//drivers/base/core.c:767): No description found for parameter 'fmt'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/base/core.c~dev_set_name-fix-missing-kernel-doc drivers/base/core.c
--- a/drivers/base/core.c~dev_set_name-fix-missing-kernel-doc
+++ a/drivers/base/core.c
@@ -769,6 +769,7 @@ static void device_remove_class_symlinks
 /**
  * dev_set_name - set a device name
  * @dev: device
+ * @fmt: format string for the device's name
  */
 int dev_set_name(struct device *dev, const char *fmt, ...)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
audit-fix-kernel-doc-parameter-notation.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch

