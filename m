From: akpm@linux-foundation.org
Subject: - maintainers-order-auerswald-alphabetically.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:08 -0800
Message-ID: <200802070022.m170MnDT006471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935080AbYBGAov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, wolfgang@iksw-muees.de, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS, order AUERSWALD alphabetically
has been removed from the -mm tree.  Its filename was
     maintainers-order-auerswald-alphabetically.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS, order AUERSWALD alphabetically
From: Jiri Slaby <jirislaby@gmail.com>

MAINTAINERS, order AUERSWALD alphabetically

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Wolfgang Muees <wolfgang@iksw-muees.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~maintainers-order-auerswald-alphabetically MAINTAINERS
--- a/MAINTAINERS~maintainers-order-auerswald-alphabetically
+++ a/MAINTAINERS
@@ -3855,6 +3855,12 @@ M:	oliver@neukum.name
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 
+USB AUERSWALD DRIVER
+P:	Wolfgang Muees
+M:	wolfgang@iksw-muees.de
+L:      linux-usb@vger.kernel.org
+S:	Maintained
+
 USB BLOCK DRIVER (UB ub)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
@@ -4005,12 +4011,6 @@ S:	Maintained
 W:	http://geocities.com/i0xox0i
 W:	http://firstlight.net/cvs
 
-USB AUERSWALD DRIVER
-P:	Wolfgang Muees
-M:	wolfgang@iksw-muees.de
-L:      linux-usb@vger.kernel.org
-S:	Maintained
-
 USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
 P:	Gary Brubaker
 M:	xavyer@ix.netcom.com
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
char-mxser-remove-special-baudrate-processing.patch
char-mxser-0-to-null-in-pointer.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
char-mxser-ioctl-cleanup.patch
char-mxser-remove-it.patch
char-mxser-add-support-for-cp-114ul.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
