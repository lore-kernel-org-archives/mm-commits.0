From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-misc-emi26c-emi62c-fix-warnings.patch removed from -mm tree
Date: Wed, 25 Jan 2012 12:42:10 -0800
Message-ID: <20120125204210.4CFE9A02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:45960 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2AYUmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 15:42:12 -0500
Received: by eaaf1 with SMTP id f1so235704eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 12:42:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/usb/misc/emi26.c & emi62.c: fix warnings
has been removed from the -mm tree.  Its filename was
     drivers-usb-misc-emi26c-emi62c-fix-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/usb/misc/emi26.c & emi62.c: fix warnings

drivers/usb/misc/emi26.c:40: warning: 'emi26_init' declared 'static' but never defined
drivers/usb/misc/emi26.c:41: warning: 'emi26_exit' declared 'static' but never defined
drivers/usb/misc/emi62.c:49: warning: 'emi62_init' declared 'static' but never defined
drivers/usb/misc/emi62.c:50: warning: 'emi62_exit' declared 'static' but never defined

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/emi26.c |    3 ---
 drivers/usb/misc/emi62.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN drivers/usb/misc/emi26.c~drivers-usb-misc-emi26c-emi62c-fix-warnings drivers/usb/misc/emi26.c
--- a/drivers/usb/misc/emi26.c~drivers-usb-misc-emi26c-emi62c-fix-warnings
+++ a/drivers/usb/misc/emi26.c
@@ -37,9 +37,6 @@ static int emi26_set_reset(struct usb_de
 static int emi26_load_firmware (struct usb_device *dev);
 static int emi26_probe(struct usb_interface *intf, const struct usb_device_id *id);
 static void emi26_disconnect(struct usb_interface *intf);
-static int __init emi26_init (void);
-static void __exit emi26_exit (void);
-
 
 /* thanks to drivers/usb/serial/keyspan_pda.c code */
 static int emi26_writememory (struct usb_device *dev, int address,
diff -puN drivers/usb/misc/emi62.c~drivers-usb-misc-emi26c-emi62c-fix-warnings drivers/usb/misc/emi62.c
--- a/drivers/usb/misc/emi62.c~drivers-usb-misc-emi26c-emi62c-fix-warnings
+++ a/drivers/usb/misc/emi62.c
@@ -46,9 +46,6 @@ static int emi62_set_reset(struct usb_de
 static int emi62_load_firmware (struct usb_device *dev);
 static int emi62_probe(struct usb_interface *intf, const struct usb_device_id *id);
 static void emi62_disconnect(struct usb_interface *intf);
-static int __init emi62_init (void);
-static void __exit emi62_exit (void);
-
 
 /* thanks to drivers/usb/serial/keyspan_pda.c code */
 static int emi62_writememory(struct usb_device *dev, int address,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

