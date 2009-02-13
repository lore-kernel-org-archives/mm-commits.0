From: akpm@linux-foundation.org
Subject: [merged] rtl8187se-depends-on-wireless_ext.patch removed from -mm tree
Date: Fri, 13 Feb 2009 11:56:01 -0800
Message-ID: <200902131956.n1DJu1ag028282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645AbZBMT4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 14:56:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     rtl8187se: depends on WIRELESS_EXT
has been removed from the -mm tree.  Its filename was
     rtl8187se-depends-on-wireless_ext.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtl8187se: depends on WIRELESS_EXT
From: Randy Dunlap <randy.dunlap@oracle.com>

rtl8187se uses wireless extensions so it needs to depend on
WIRELESS_EXT (or select it).

drivers/staging/rtl8187se/r8180_core.c:5973: error: 'struct net_device' has no member named 'wireless_handlers'
drivers/staging/rtl8187se/r8180_core.c:5982: error: 'struct net_device' has no member named 'wireless_handlers'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8187se/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/rtl8187se/Kconfig~rtl8187se-depends-on-wireless_ext drivers/staging/rtl8187se/Kconfig
--- a/drivers/staging/rtl8187se/Kconfig~rtl8187se-depends-on-wireless_ext
+++ a/drivers/staging/rtl8187se/Kconfig
@@ -1,5 +1,6 @@
 config RTL8187SE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
 	depends on PCI
+	depends on WIRELESS_EXT
 	default N
 	---help---
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uv-fix-header-struct-usage.patch
x86-dell-laptop-depends-on-power_supply.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-fix-romc-kernel-doc-warning.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
documentation-ignore-byproducts-from-latex.patch
docbook-split-kernel-api-add-device-drivers-book.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch

