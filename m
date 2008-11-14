From: akpm@linux-foundation.org
Subject: + documentation-kernel-parameterstxt-add-min_addr-fix-max_addr.patch added to -mm tree
Date: Thu, 13 Nov 2008 16:37:15 -0800
Message-ID: <200811140037.mAE0bF8U025704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbYKNAh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 19:37:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     Documentation/kernel-parameters.txt: add min_addr, fix max_addr
has been added to the -mm tree.  Its filename is
     documentation-kernel-parameterstxt-add-min_addr-fix-max_addr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/kernel-parameters.txt: add min_addr, fix max_addr
From: Randy Dunlap <randy.dunlap@oracle.com>

Add "min_addr" documentation.
For "max_addr", add nn before [KMG] since a number is needed and this
is consistent with other uses of [KMG].

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-add-min_addr-fix-max_addr Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-add-min_addr-fix-max_addr
+++ a/Documentation/kernel-parameters.txt
@@ -1218,8 +1218,8 @@ and is between 256 and 4096 characters. 
 			it is equivalent to "nosmp", which also disables
 			the IO APIC.
 
-	max_addr=[KMG]	[KNL,BOOT,ia64] All physical memory greater than or
-			equal to this physical address is ignored.
+	max_addr=nn[KMG]	[KNL,BOOT,ia64] All physical memory greater than
+			or equal to this physical address is ignored.
 
 	max_luns=	[SCSI] Maximum number of LUNs to probe.
 			Should be between 1 and 2^32-1.
@@ -1319,6 +1319,9 @@ and is between 256 and 4096 characters. 
 
 	mga=		[HW,DRM]
 
+	min_addr=nn[KMG]	[KNL,BOOT,ia64] All physical memory below this
+			physical address is ignored.
+
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
 			parameter allows control of the logging verbosity for
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch
documentation-kernel-parameterstxt-add-min_addr-fix-max_addr.patch

