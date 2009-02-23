From: akpm@linux-foundation.org
Subject: [merged] docsrc-use-config-instead-of-menuconfig.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:44 -0800
Message-ID: <200902232006.n1NK6i9O013418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828AbZBWUQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:16:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docsrc: use config instead of menuconfig
has been removed from the -mm tree.  Its filename was
     docsrc-use-config-instead-of-menuconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docsrc: use config instead of menuconfig
From: Randy Dunlap <randy.dunlap@oracle.com>

BUILD_DOCSRC should be controlled by "config" instead of "menuconfig".
I have no idea how I managed to use "menuconfig" here.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~docsrc-use-config-instead-of-menuconfig lib/Kconfig.debug
--- a/lib/Kconfig.debug~docsrc-use-config-instead-of-menuconfig
+++ a/lib/Kconfig.debug
@@ -838,7 +838,7 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
-menuconfig BUILD_DOCSRC
+config BUILD_DOCSRC
 	bool "Build targets in Documentation/ tree"
 	depends on HEADERS_CHECK
 	help
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
kbuild-check-for-select-dependency-errors-on-config-load.patch
kbuild-check-for-select-dependency-errors-on-config-load-checkpatch-fixes.patch
isdn-fix-sc-shmem-printk-format-warning.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

