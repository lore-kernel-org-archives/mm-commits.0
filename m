From: akpm@linux-foundation.org
Subject: - wireless-rt2x00-fix-driver-menu-indenting.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:31 -0700
Message-ID: <200803250019.m2P0JV9K032692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbYCYA3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, IvDoorn@gmail.com, m.bueker@berlin.de, mm-commits@vger.kernel.org


The patch titled
     wireless: rt2x00: fix driver menu indenting
has been removed from the -mm tree.  Its filename was
     wireless-rt2x00-fix-driver-menu-indenting.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: wireless: rt2x00: fix driver menu indenting
=46rom: Randy Dunlap <randy.dunlap@oracle.com>

Michael B=FCker reports that the RT2x00 drivers are not indented as the=
y
should be, so use proper dependencies to make them be indented as expec=
ted.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael B=FCker <m.bueker@berlin.de>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rt2x00/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/wireless/rt2x00/Kconfig~wireless-rt2x00-fix-drive=
r-menu-indenting drivers/net/wireless/rt2x00/Kconfig
--- a/drivers/net/wireless/rt2x00/Kconfig~wireless-rt2x00-fix-driver-me=
nu-indenting
+++ a/drivers/net/wireless/rt2x00/Kconfig
@@ -11,18 +11,17 @@ config RT2X00
 	  will also be created. That library (when the driver is built as
 	  a module) will be called "rt2x00lib.ko".
=20
+if RT2X00
+
 config RT2X00_LIB
 	tristate
-	depends on RT2X00
=20
 config RT2X00_LIB_PCI
 	tristate
-	depends on RT2X00
 	select RT2X00_LIB
=20
 config RT2X00_LIB_USB
 	tristate
-	depends on RT2X00
 	select RT2X00_LIB
=20
 config RT2X00_LIB_FIRMWARE
@@ -39,7 +38,7 @@ config RT2X00_LIB_RFKILL
=20
 config RT2400PCI
 	tristate "Ralink rt2400 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
@@ -58,7 +57,7 @@ config RT2400PCI_RFKILL
=20
 config RT2500PCI
 	tristate "Ralink rt2500 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
@@ -77,7 +76,7 @@ config RT2500PCI_RFKILL
=20
 config RT61PCI
 	tristate "Ralink rt61 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select EEPROM_93CX6
@@ -97,7 +96,7 @@ config RT61PCI_RFKILL
=20
 config RT2500USB
 	tristate "Ralink rt2500 usb support"
-	depends on RT2X00 && USB
+	depends on USB
 	select RT2X00_LIB_USB
 	---help---
 	  This is an experimental driver for the Ralink rt2500 wireless chip.
@@ -106,7 +105,7 @@ config RT2500USB
=20
 config RT73USB
 	tristate "Ralink rt73 usb support"
-	depends on RT2X00 && USB
+	depends on USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
 	---help---
@@ -128,3 +127,4 @@ config RT2X00_DEBUG
 	---help---
 	  Enable debugging output for all rt2x00 modules
=20
+endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com ar=
e

origin.patch
git-drm-drivers-char-drm-ati_pcigartc-fix-printk-warning.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fi=
x.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.pa=
tch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
dma-mapping-add-dma_map_attrs-interfaces.patch
dma-mapping-document-dma_map_attrs-interfaces.patch
dma-mapping-ia64-update-ia64-machvecs-swiotlbc.patch
dma-mapping-ib-expand-ib_umem_get-prototype.patch
dma-mapping-ib-expand-ib_umem_get-prototype-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
