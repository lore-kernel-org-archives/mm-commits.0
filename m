From: akpm@linux-foundation.org
Subject: + drivers-firmware-sigmac-needs-module_license.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:33:57 -0700
Message-ID: <201107222233.p6MMXvch019065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772Ab1GVWeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, stable@kernel.org, vapier@gentoo.org


The patch titled
     drivers/firmware/sigma.c needs MODULE_LICENSE
has been added to the -mm tree.  Its filename is
     drivers-firmware-sigmac-needs-module_license.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mm-truncatec-fix-build-for-config_block-not-enabled.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
um-clean-up-vm-flagsh.patch
asm-generic-iomaph-add-stubs-for-pci-iomap-iounmap.patch
kernel-configsc-include-module_-when-config_ikconfig_proc=n.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-firmware-sigmac-needs-module_license.patch
misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

