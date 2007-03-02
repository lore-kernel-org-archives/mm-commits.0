From: akpm@linux-foundation.org
Subject: - git-hid-fix.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:43:11 -0800
Message-ID: <200703020443.l224hBuE032663@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422879AbXCBEnV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:43:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     git-hid fix
has been removed from the -mm tree.  Its filename was
     git-hid-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-hid fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/Makefile |    3 ++-
 drivers/usb/input/Makefile  |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/hid/usbhid/Makefile~git-hid-fix drivers/hid/usbhid/Makefile
--- a/drivers/hid/usbhid/Makefile~git-hid-fix
+++ a/drivers/hid/usbhid/Makefile
@@ -30,4 +30,5 @@ ifeq ($(CONFIG_HID_FF),y)
 endif
 
 obj-$(CONFIG_USB_HID)	+= usbhid.o
-
+obj-$(CONFIG_USB_KBD)	+= usbkbd.o
+obj-$(CONFIG_USB_MOUSE)	+= usbmouse.o
diff -puN drivers/usb/input/Makefile~git-hid-fix drivers/usb/input/Makefile
--- a/drivers/usb/input/Makefile~git-hid-fix
+++ a/drivers/usb/input/Makefile
@@ -10,10 +10,8 @@ wacom-objs	:= wacom_wac.o wacom_sys.o
 obj-$(CONFIG_USB_AIPTEK)	+= aiptek.o
 obj-$(CONFIG_USB_ATI_REMOTE)	+= ati_remote.o
 obj-$(CONFIG_USB_ATI_REMOTE2)	+= ati_remote2.o
-obj-$(CONFIG_USB_KBD)		+= usbkbd.o
 obj-$(CONFIG_USB_KBTAB)		+= kbtab.o
 obj-$(CONFIG_USB_KEYSPAN_REMOTE)	+= keyspan_remote.o
-obj-$(CONFIG_USB_MOUSE)		+= usbmouse.o
 obj-$(CONFIG_USB_MTOUCH)	+= mtouchusb.o
 obj-$(CONFIG_USB_ITMTOUCH)	+= itmtouch.o
 obj-$(CONFIG_USB_EGALAX)	+= touchkitusb.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-hid-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
log-reason-why-tsc-was-marked-unstable-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
