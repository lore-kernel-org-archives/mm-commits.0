From: akpm@linux-foundation.org
Subject: [merged] maintainers-document-and-add-q-patchwork-queue-entries.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:18 -0800
Message-ID: <201003091907.o29J7I2g031326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab0CITIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:08:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: document and add "Q" patchwork queue entries
has been removed from the -mm tree.  Its filename was
     maintainers-document-and-add-q-patchwork-queue-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: document and add "Q" patchwork queue entries
From: Joe Perches <joe@perches.com>

Patchwork queues show the acceptance/rejection state of submitted patches
for various MAINTAINER trees.  Document their existence.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-document-and-add-q-patchwork-queue-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-document-and-add-q-patchwork-queue-entries
+++ a/MAINTAINERS
@@ -71,6 +71,7 @@ Descriptions of section entries:
 	M: Mail patches to: FullName <address@domain>
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
+	Q: Patchwork web based patch tracking system site
 	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
@@ -182,6 +183,7 @@ M:	Ron Minnich <rminnich@sandia.gov>
 M:	Latchesar Ionkov <lucho@ionkov.net>
 L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
+Q:	http://patchwork.kernel.org/project/v9fs-devel/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
 S:	Maintained
 F:	Documentation/filesystems/9p.txt
@@ -238,6 +240,7 @@ ACPI
 M:	Len Brown <lenb@kernel.org>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
+Q:	http://patchwork.kernel.org/project/linux-acpi/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
 F:	drivers/acpi/
@@ -1331,6 +1334,7 @@ BTRFS FILE SYSTEM
 M:	Chris Mason <chris.mason@oracle.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
+Q:	http://patchwork.kernel.org/project/linux-btrfs/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
 S:	Maintained
 F:	Documentation/filesystems/btrfs.txt
@@ -1495,6 +1499,7 @@ M:	Steve French <sfrench@samba.org>
 L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
+Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/cifs.txt
@@ -1781,6 +1786,7 @@ DEVICE-MAPPER  (LVM)
 P:	Alasdair Kergon
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
+Q:	http://patchwork.kernel.org/project/dm-devel/list/
 S:	Maintained
 F:	Documentation/device-mapper/
 F:	drivers/md/dm*
@@ -2125,6 +2131,7 @@ M:	"Theodore Ts'o" <tytso@mit.edu>
 M:	Andreas Dilger <adilger@sun.com>
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
+Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
 S:	Maintained
 F:	Documentation/filesystems/ext4.txt
 F:	fs/ext4/
@@ -2709,6 +2716,7 @@ F:	drivers/scsi/ips.*
 IDE SUBSYSTEM
 M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-ide@vger.kernel.org
+Q:	http://patchwork.ozlabs.org/project/linux-ide/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
 S:	Maintained
 F:	Documentation/ide/
@@ -2763,6 +2771,7 @@ M:	Sean Hefty <sean.hefty@intel.com>
 M:	Hal Rosenstock <hal.rosenstock@gmail.com>
 L:	linux-rdma@vger.kernel.org
 W:	http://www.openib.org/
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 F:	Documentation/infiniband/
@@ -2782,6 +2791,7 @@ INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHS
 M:	Dmitry Torokhov <dmitry.torokhov@gmail.com>
 M:	Dmitry Torokhov <dtor@mail.ru>
 L:	linux-input@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-input/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
@@ -3091,6 +3101,7 @@ F:	drivers/hwmon/k8temp.c
 KCONFIG
 M:	Roman Zippel <zippel@linux-m68k.org>
 L:	linux-kbuild@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-kbuild/list/
 S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
@@ -3304,6 +3315,7 @@ M:	Benjamin Herrenschmidt <benh@kernel.c
 M:	Paul Mackerras <paulus@samba.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
+Q:	http://patchwork.ozlabs.org/project/linuxppc-dev/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
 S:	Supported
 F:	Documentation/powerpc/
@@ -3560,6 +3572,7 @@ M:	Mauro Carvalho Chehab <mchehab@infrad
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
+Q:	http://patchwork.kernel.org/project/linux-media/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/dvb/
@@ -3595,8 +3608,9 @@ F:	mm/memcontrol.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2@infradead.org>
-W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
+W:	http://www.linux-mtd.infradead.org/
+Q:	http://patchwork.ozlabs.org/project/linux-mtd/list/
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 F:	drivers/mtd/
@@ -3856,6 +3870,7 @@ S:	Maintained
 NETWORKING [WIRELESS]
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/mac80211/
@@ -3948,6 +3963,7 @@ M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
 W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
+Q:	http://patchwork.kernel.org/project/linux-omap/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
 S:	Maintained
 F:	arch/arm/*omap*/
@@ -4174,6 +4190,7 @@ M:	Helge Deller <deller@gmx.de>
 M:	"James E.J. Bottomley" <jejb@parisc-linux.org>
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
+Q:	http://patchwork.kernel.org/project/linux-parisc/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 S:	Maintained
 F:	arch/parisc/
@@ -4216,6 +4233,7 @@ F:	Documentation/powerpc/eeh-pci-error-r
 PCI SUBSYSTEM
 M:	Jesse Barnes <jbarnes@virtuousgeek.org>
 L:	linux-pci@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-pci/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
 F:	Documentation/PCI/
@@ -4593,6 +4611,7 @@ F:	include/linux/rtc.h
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
 L:	rtc-linux@googlegroups.com
+Q:	http://patchwork.ozlabs.org/project/rtc-linux/list/
 S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
@@ -4960,6 +4979,7 @@ F:	drivers/*/*/*s3c2410*
 TI DAVINCI MACHINE SUPPORT
 P:	Kevin Hilman
 M:	davinci-linux-open-source@linux.davincidsp.com
+Q:	http://patchwork.kernel.org/project/linux-davinci/list/
 S:	Supported
 F:	arch/arm/mach-davinci
 
@@ -5125,6 +5145,7 @@ F:	include/sound/soc*
 SPARC + UltraSPARC (sparc/sparc64)
 M:	"David S. Miller" <davem@davemloft.net>
 L:	sparclinux@vger.kernel.org
+Q:	http://patchwork.ozlabs.org/project/sparclinux/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
 S:	Maintained
@@ -5140,6 +5161,7 @@ SPI SUBSYSTEM
 M:	David Brownell <dbrownell@users.sourceforge.net>
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
+Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
 S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/
@@ -5216,6 +5238,7 @@ SUPERH
 M:	Paul Mundt <lethal@linux-sh.org>
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
+Q:	http://patchwork.kernel.org/project/linux-sh/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
 F:	Documentation/sh/
@@ -6179,6 +6202,7 @@ F:	drivers/serial/zs.*
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/LKML/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 S:	Buried alive in reporters
 F:	*
_

Patches currently in -mm which might be from joe@perches.com are

fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
drivers-video-via-fix-continuation-line-formats.patch

