From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-uml-fix-2.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:55:14 -0800
Message-ID: <200612080855.kB88tEpa014101@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425241AbWLHIzX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:55:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     usb: escaped ktermios conversion
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-uml-fix-2.patch

This patch was dropped because it was folded into tty-switch-to-ktermios.patch

------------------------------------------------------
Subject: usb: escaped ktermios conversion
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/serial/sierra.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/sierra.c~tty-switch-to-ktermios-uml-fix-2 drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~tty-switch-to-ktermios-uml-fix-2
+++ a/drivers/usb/serial/sierra.c
@@ -145,7 +145,7 @@ static void sierra_break_ctl(struct usb_
 }
 
 static void sierra_set_termios(struct usb_serial_port *port,
-			struct termios *old_termios)
+			struct ktermios *old_termios)
 {
 	dbg("%s", __FUNCTION__);
 
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
tty-signal-tty-locking.patch
pci-mxser-pci-refcounts.patch
tty-preparatory-structures-for-termios-revamp.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty-switch-to-ktermios-uml-fix-2.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-update.patch
termios-enable-new-style-termios-ioctls-on-x86-64.patch
char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
ide-more-conversion-to-pci_get-apis.patch
igafb-switch-to-pci_get-api.patch

