From: akpm@linux-foundation.org
Subject: [merged] maintainers-use-tabs-consistently.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:01 -0700
Message-ID: <552fe965.dbxT4lkYYO7MKw0c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbbDPQtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Use tabs consistently
has been removed from the -mm tree.  Its filename was
     maintainers-use-tabs-consistently.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: Use tabs consistently

Consistently use a single tab after the "specifier:" type.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   70 +++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff -puN MAINTAINERS~maintainers-use-tabs-consistently MAINTAINERS
--- a/MAINTAINERS~maintainers-use-tabs-consistently
+++ a/MAINTAINERS
@@ -625,16 +625,16 @@ F:	drivers/iommu/amd_iommu*.[ch]
 F:	include/linux/amd-iommu.h
 
 AMD KFD
-M:      Oded Gabbay <oded.gabbay@amd.com>
-L:      dri-devel@lists.freedesktop.org
-T:      git git://people.freedesktop.org/~gabbayo/linux.git
-S:      Supported
-F:      drivers/gpu/drm/amd/amdkfd/
+M:	Oded Gabbay <oded.gabbay@amd.com>
+L:	dri-devel@lists.freedesktop.org
+T:	git git://people.freedesktop.org/~gabbayo/linux.git
+S:	Supported
+F:	drivers/gpu/drm/amd/amdkfd/
 F:	drivers/gpu/drm/amd/include/cik_structs.h
 F:	drivers/gpu/drm/amd/include/kgd_kfd_interface.h
-F:      drivers/gpu/drm/radeon/radeon_kfd.c
-F:      drivers/gpu/drm/radeon/radeon_kfd.h
-F:      include/uapi/linux/kfd_ioctl.h
+F:	drivers/gpu/drm/radeon/radeon_kfd.c
+F:	drivers/gpu/drm/radeon/radeon_kfd.h
+F:	include/uapi/linux/kfd_ioctl.h
 
 AMD MICROCODE UPDATE SUPPORT
 M:	Borislav Petkov <bp@alien8.de>
@@ -1967,10 +1967,10 @@ F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 
 BECKHOFF CX5020 ETHERCAT MASTER DRIVER
-M: Dariusz Marcinkiewicz <reksio@newterm.pl>
-L: netdev@vger.kernel.org
-S: Maintained
-F: drivers/net/ethernet/ec_bhf.c
+M:	Dariusz Marcinkiewicz <reksio@newterm.pl>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/ec_bhf.c
 
 BFS FILE SYSTEM
 M:	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
@@ -2895,11 +2895,11 @@ S:	Supported
 F:	drivers/net/ethernet/chelsio/cxgb3/
 
 CXGB3 ISCSI DRIVER (CXGB3I)
-M:      Karen Xie <kxie@chelsio.com>
-L:      linux-scsi@vger.kernel.org
-W:      http://www.chelsio.com
-S:      Supported
-F:      drivers/scsi/cxgbi/cxgb3i
+M:	Karen Xie <kxie@chelsio.com>
+L:	linux-scsi@vger.kernel.org
+W:	http://www.chelsio.com
+S:	Supported
+F:	drivers/scsi/cxgbi/cxgb3i
 
 CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
 M:	Steve Wise <swise@chelsio.com>
@@ -2916,11 +2916,11 @@ S:	Supported
 F:	drivers/net/ethernet/chelsio/cxgb4/
 
 CXGB4 ISCSI DRIVER (CXGB4I)
-M:      Karen Xie <kxie@chelsio.com>
-L:      linux-scsi@vger.kernel.org
-W:      http://www.chelsio.com
-S:      Supported
-F:      drivers/scsi/cxgbi/cxgb4i
+M:	Karen Xie <kxie@chelsio.com>
+L:	linux-scsi@vger.kernel.org
+W:	http://www.chelsio.com
+S:	Supported
+F:	drivers/scsi/cxgbi/cxgb4i
 
 CXGB4 IWARP RNIC DRIVER (IW_CXGB4)
 M:	Steve Wise <swise@chelsio.com>
@@ -5222,7 +5222,7 @@ F:	arch/x86/kernel/tboot.c
 INTEL WIRELESS WIMAX CONNECTION 2400
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
-L:     wimax@linuxwimax.org (subscribers-only)
+L:	wimax@linuxwimax.org (subscribers-only)
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.i2400m
@@ -5918,7 +5918,7 @@ F:	arch/powerpc/platforms/512x/
 F:	arch/powerpc/platforms/52xx/
 
 LINUX FOR POWERPC EMBEDDED PPC4XX
-M:  Alistair Popple <alistair@popple.id.au>
+M:	Alistair Popple <alistair@popple.id.au>
 M:	Matt Porter <mporter@kernel.crashing.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@lists.ozlabs.org
@@ -6391,7 +6391,7 @@ S:	Supported
 F:	drivers/watchdog/mena21_wdt.c
 
 MEN CHAMELEON BUS (mcb)
-M:  	Johannes Thumshirn <johannes.thumshirn@men.de>
+M:	Johannes Thumshirn <johannes.thumshirn@men.de>
 S:	Supported
 F:	drivers/mcb/
 F:	include/linux/mcb.h
@@ -7947,10 +7947,10 @@ L:	rtc-linux@googlegroups.com
 S:	Maintained
 
 QAT DRIVER
-M:      Tadeusz Struk <tadeusz.struk@intel.com>
-L:      qat-linux@intel.com
-S:      Supported
-F:      drivers/crypto/qat/
+M:	Tadeusz Struk <tadeusz.struk@intel.com>
+L:	qat-linux@intel.com
+S:	Supported
+F:	drivers/crypto/qat/
 
 QIB DRIVER
 M:	Mike Marciniszyn <infinipath@intel.com>
@@ -10120,11 +10120,11 @@ F:	include/linux/cdrom.h
 F:	include/uapi/linux/cdrom.h
 
 UNISYS S-PAR DRIVERS
-M:     Benjamin Romer <benjamin.romer@unisys.com>
-M:     David Kershner <david.kershner@unisys.com>
-L:     sparmaintainer@unisys.com (Unisys internal)
-S:     Supported
-F:     drivers/staging/unisys/
+M:	Benjamin Romer <benjamin.romer@unisys.com>
+M:	David Kershner <david.kershner@unisys.com>
+L:	sparmaintainer@unisys.com (Unisys internal)
+S:	Supported
+F:	drivers/staging/unisys/
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
 M:	Vinayak Holikatti <vinholikatti@gmail.com>
@@ -10681,7 +10681,7 @@ F:	drivers/media/rc/winbond-cir.c
 WIMAX STACK
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
-L:     wimax@linuxwimax.org (subscribers-only)
+L:	wimax@linuxwimax.org (subscribers-only)
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.wimax
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

