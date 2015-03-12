From: akpm@linux-foundation.org
Subject: + maintainers-use-tabs-consistently.patch added to -mm tree
Date: Thu, 12 Mar 2015 13:01:02 -0700
Message-ID: <5501f07e.1/PNIm8Sg31hP1A6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbbCLUBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Use tabs consistently
has been added to the -mm tree.  Its filename is
     maintainers-use-tabs-consistently.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-use-tabs-consistently.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-use-tabs-consistently.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
@@ -1954,10 +1954,10 @@ F:	Documentation/filesystems/befs.txt
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
@@ -2876,11 +2876,11 @@ S:	Supported
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
@@ -2897,11 +2897,11 @@ S:	Supported
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
@@ -5177,7 +5177,7 @@ F:	arch/x86/kernel/tboot.c
 INTEL WIRELESS WIMAX CONNECTION 2400
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
-L:     wimax@linuxwimax.org (subscribers-only)
+L:	wimax@linuxwimax.org (subscribers-only)
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.i2400m
@@ -5871,7 +5871,7 @@ F:	arch/powerpc/platforms/512x/
 F:	arch/powerpc/platforms/52xx/
 
 LINUX FOR POWERPC EMBEDDED PPC4XX
-M:  Alistair Popple <alistair@popple.id.au>
+M:	Alistair Popple <alistair@popple.id.au>
 M:	Matt Porter <mporter@kernel.crashing.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@lists.ozlabs.org
@@ -6343,7 +6343,7 @@ S:	Supported
 F:	drivers/watchdog/mena21_wdt.c
 
 MEN CHAMELEON BUS (mcb)
-M:  	Johannes Thumshirn <johannes.thumshirn@men.de>
+M:	Johannes Thumshirn <johannes.thumshirn@men.de>
 S:	Supported
 F:	drivers/mcb/
 F:	include/linux/mcb.h
@@ -7894,10 +7894,10 @@ L:	rtc-linux@googlegroups.com
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
@@ -10067,11 +10067,11 @@ F:	include/linux/cdrom.h
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
@@ -10615,7 +10615,7 @@ F:	drivers/media/rc/winbond-cir.c
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
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
linux-next.patch

