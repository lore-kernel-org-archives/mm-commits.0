From: akpm@linux-foundation.org
Subject: - add-maintainers-entry-for-ioc3-serial-driver.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:08 -0700
Message-ID: <200708311656.l7VGu8JB017463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760489AbXHaQ4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, pfg@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Add MAINTAINERS entry for IOC3 serial driver
has been removed from the -mm tree.  Its filename was
     add-maintainers-entry-for-ioc3-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add MAINTAINERS entry for IOC3 serial driver
From: Ralf Baechle <ralf@linux-mips.org>

The IOC3 is a multifunction device but not in sense of the PCI
specification.  Currently its ethernet and serial functionality are
supported by two separate drivers authored and maintained by different
people, so MAINTAINERS should reflect that.

Cc: Patrick Gefre <pfg@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~add-maintainers-entry-for-ioc3-serial-driver MAINTAINERS
--- a/MAINTAINERS~add-maintainers-entry-for-ioc3-serial-driver
+++ a/MAINTAINERS
@@ -2057,12 +2057,18 @@ L:	http://lists.sourceforge.net/mailman/
 W:	http://ipw2200.sourceforge.net
 S:	Supported
 
-IOC3 DRIVER
+IOC3 ETHERNET DRIVER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-mips@linux-mips.org
 S:	Maintained
 
+IOC3 SERIAL DRIVER
+P:	Pat Gefre
+M:	pfg@sgi.com
+L:	linux-kernel@linux-mips.org
+S:	Maintained
+
 IP MASQUERADING:
 P:	Juanjo Ciarlante
 M:	jjciarla@raiz.uncu.edu.ar
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-netdev-all.patch
ioc3-program-uart-predividers.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
vt-fix-warnings-in-selectionh.patch
define-global-bit-macro.patch
