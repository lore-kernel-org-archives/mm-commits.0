From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-unnecessary-characters.patch
 removed from -mm tree
Date: Wed, 12 Feb 2020 10:43:25 -0800
Message-ID: <20200212184325.yjucGN3xH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgBLSn0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 13:43:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgolaszewski@baylibre.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove unnecessary ':' characters
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unnecessary-characters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: MAINTAINERS: remove unnecessary ':' characters

Commit e567cb3fef30 ("MAINTAINERS: add an entry for kfifo") added a new
entry to MAINTAINERS. Following the example of the previous entry on the
list I added a trailing ':' character at the end of the title line.

This however results in rather strange looking output from
scripts/get_maintainer.pl:

$ ./scripts/get_maintainer.pl ./0001-kfifo.patch
Stefani Seibold <stefani@seibold.net> (maintainer:KFIFO:)
linux-kernel@vger.kernel.org (open list)

It turns out there are more entries like this. Fix the entire file by
removing all trailing colons.

Link: http://lkml.kernel.org/r/20200130135515.30359-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/MAINTAINERS~maintainers-remove-unnecessary-characters
+++ a/MAINTAINERS
@@ -3909,7 +3909,7 @@ S:	Supported
 F:	Documentation/filesystems/ceph.txt
 F:	fs/ceph/
 
-CERTIFICATE HANDLING:
+CERTIFICATE HANDLING
 M:	David Howells <dhowells@redhat.com>
 M:	David Woodhouse <dwmw2@infradead.org>
 L:	keyrings@vger.kernel.org
@@ -3919,7 +3919,7 @@ F:	certs/
 F:	scripts/sign-file.c
 F:	scripts/extract-cert.c
 
-CERTIFIED WIRELESS USB (WUSB) SUBSYSTEM:
+CERTIFIED WIRELESS USB (WUSB) SUBSYSTEM
 L:	devel@driverdev.osuosl.org
 S:	Obsolete
 F:	drivers/staging/wusbcore/
@@ -7047,7 +7047,7 @@ L:	kvm@vger.kernel.org
 S:	Supported
 F:	drivers/uio/uio_pci_generic.c
 
-GENERIC VDSO LIBRARY:
+GENERIC VDSO LIBRARY
 M:	Andy Lutomirski <luto@kernel.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
 M:	Vincenzo Frascino <vincenzo.frascino@arm.com>
@@ -9278,7 +9278,7 @@ F:	include/keys/trusted-type.h
 F:	security/keys/trusted.c
 F:	include/keys/trusted.h
 
-KEYS/KEYRINGS:
+KEYS/KEYRINGS
 M:	David Howells <dhowells@redhat.com>
 M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
 L:	keyrings@vger.kernel.org
@@ -9291,7 +9291,7 @@ F:	include/uapi/linux/keyctl.h
 F:	include/keys/
 F:	security/keys/
 
-KFIFO:
+KFIFO
 M:	Stefani Seibold <stefani@seibold.net>
 S:	Maintained
 F:	lib/kfifo.c
@@ -11491,7 +11491,7 @@ F:	drivers/scsi/mac_scsi.*
 F:	drivers/scsi/sun3_scsi.*
 F:	drivers/scsi/sun3_scsi_vme.c
 
-NCSI LIBRARY:
+NCSI LIBRARY
 M:	Samuel Mendoza-Jonas <sam@mendozajonas.com>
 S:	Maintained
 F:	net/ncsi/
@@ -13519,7 +13519,7 @@ L:	linuxppc-dev@lists.ozlabs.org
 S:	Maintained
 F:	drivers/block/ps3vram.c
 
-PSAMPLE PACKET SAMPLING SUPPORT:
+PSAMPLE PACKET SAMPLING SUPPORT
 M:	Yotam Gigi <yotam.gi@gmail.com>
 S:	Maintained
 F:	net/psample
@@ -17087,7 +17087,7 @@ S:	Maintained
 F:	Documentation/admin-guide/ufs.rst
 F:	fs/ufs/
 
-UHID USERSPACE HID IO DRIVER:
+UHID USERSPACE HID IO DRIVER
 M:	David Herrmann <dh.herrmann@googlemail.com>
 L:	linux-input@vger.kernel.org
 S:	Maintained
@@ -17101,18 +17101,18 @@ S:	Maintained
 F:	drivers/usb/common/ulpi.c
 F:	include/linux/ulpi/
 
-ULTRA-WIDEBAND (UWB) SUBSYSTEM:
+ULTRA-WIDEBAND (UWB) SUBSYSTEM
 L:	devel@driverdev.osuosl.org
 S:	Obsolete
 F:	drivers/staging/uwb/
 
-UNICODE SUBSYSTEM:
+UNICODE SUBSYSTEM
 M:	Gabriel Krisman Bertazi <krisman@collabora.com>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 F:	fs/unicode/
 
-UNICORE32 ARCHITECTURE:
+UNICORE32 ARCHITECTURE
 M:	Guan Xuetao <gxt@pku.edu.cn>
 W:	http://mprc.pku.edu.cn/~guanxuetao/linux
 S:	Maintained
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are

maintainers-add-an-entry-for-kfifo.patch
