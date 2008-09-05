From: akpm@linux-foundation.org
Subject: - hid-fix-gyration-build-error.patch removed from -mm tree
Date: Fri, 05 Sep 2008 13:13:53 -0700
Message-ID: <200809052013.m85KDrUC018431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbYIEUOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2008 16:14:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid: fix gyration build error
has been removed from the -mm tree.  Its filename was
     hid-fix-gyration-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: fix gyration build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix config symbol name in ifdef to fix build error:

ERROR: "hid_compat_gyration" [drivers/hid/hid-dummy.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-dummy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/hid-dummy.c~hid-fix-gyration-build-error drivers/hid/hid-dummy.c
--- a/drivers/hid/hid-dummy.c~hid-fix-gyration-build-error
+++ a/drivers/hid/hid-dummy.c
@@ -28,7 +28,7 @@ static int __init hid_dummy_init(void)
 #ifdef CONFIG_HID_EZKEY_MODULE
 	HID_COMPAT_CALL_DRIVER(ezkey);
 #endif
-#ifdef CONFIG_HID_EZKEY_MODULE
+#ifdef CONFIG_HID_GYRATION_MODULE
 	HID_COMPAT_CALL_DRIVER(gyration);
 #endif
 #ifdef CONFIG_HID_LOGITECH_MODULE
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
ath9k-uses-needs-led_classdev_register.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

