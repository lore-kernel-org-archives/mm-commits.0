From: akpm@linux-foundation.org
Subject: [merged] drivers-firmware-sigmac-needs-module_license.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:59 -0700
Message-ID: <201107260755.p6Q7t2pK003411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252Ab1GZHzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, stable@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     drivers/firmware/sigma.c needs MODULE_LICENSE
has been removed from the -mm tree.  Its filename was
     drivers-firmware-sigmac-needs-module_license.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/firmware/sigma.c needs MODULE_LICENSE
From: Randy Dunlap <rdunlap@xenotime.net>

Fix module tainting message:
sigma: module license 'unspecified' taints kernel.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/sigma.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/firmware/sigma.c~drivers-firmware-sigmac-needs-module_license drivers/firmware/sigma.c
--- a/drivers/firmware/sigma.c~drivers-firmware-sigmac-needs-module_license
+++ a/drivers/firmware/sigma.c
@@ -11,6 +11,7 @@
 #include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/sigma.h>
 
 /* Return: 0==OK, <0==error, =1 ==no more actions */
@@ -113,3 +114,5 @@ int process_sigma_firmware(struct i2c_cl
 	return ret;
 }
 EXPORT_SYMBOL(process_sigma_firmware);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

