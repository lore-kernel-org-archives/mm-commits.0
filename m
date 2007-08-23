From: akpm@linux-foundation.org
Subject: + add-maintainers-entry-for-ioc3-serial-driver.patch added to -mm tree
Date: Thu, 23 Aug 2007 14:08:10 -0700
Message-ID: <200708232108.l7NL8AhA026992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049AbXHWVI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 17:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, pfg@sgi.com


The patch titled
     Add MAINTAINERS entry for IOC3 serial driver
has been added to the -mm tree.  Its filename is
     add-maintainers-entry-for-ioc3-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~add-maintainers-entry-for-ioc3-serial-driver MAINTAINERS
--- a/MAINTAINERS~add-maintainers-entry-for-ioc3-serial-driver
+++ a/MAINTAINERS
@@ -2126,12 +2126,18 @@ W:	http://intellinuxwireless.org
 T:	git git://intellinuxwireless.org/repos/iwlwifi
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

serial_txx9-fix-modem-control-line-handling.patch
newport_con-warning-fix.patch
au1100fb-move-au1100fb_fb_blank-beforce.patch
fix-font-dependency-for-sgi-newport-console-driver.patch
add-maintainers-entry-for-ioc3-serial-driver.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-irix_getcontext-will-always-fail-efault.patch
git-mtd.patch
git-netdev-all.patch
dont-use-gfp_dma-for-zone-allocation.patch
sgiseeq-fix-return-type-of-sgiseeq_remove.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
define-global-bit-macro.patch
