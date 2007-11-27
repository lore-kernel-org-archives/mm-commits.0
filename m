From: akpm@linux-foundation.org
Subject: + maintainers-order-auerswald-alphabetically.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:17:17 -0800
Message-ID: <200711270517.lAR5HHib028575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46916 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbXK0FR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, ku@anemoi.localdomain, wolfgang@iksw-muees.de


The patch titled
     MAINTAINERS, order AUERSWALD alphabetically
has been added to the -mm tree.  Its filename is
     maintainers-order-auerswald-alphabetically.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS, order AUERSWALD alphabetically
From: Jiri Slaby <jirislaby@gmail.com>

MAINTAINERS, order AUERSWALD alphabetically

Signed-off-by: Jiri Slaby <ku@anemoi.localdomain>
Cc: Wolfgang Muees <wolfgang@iksw-muees.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~maintainers-order-auerswald-alphabetically MAINTAINERS
--- a/MAINTAINERS~maintainers-order-auerswald-alphabetically
+++ a/MAINTAINERS
@@ -3864,6 +3864,12 @@ M:	oliver@neukum.name
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
@@ -4014,12 +4020,6 @@ S:	Maintained
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

net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
git-watchdog.patch
git-wireless.patch
drm-i915-fix-pointer-strip.patch
maintainers-order-auerswald-alphabetically.patch
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
moxa-first-pass-at-termios-reporting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
