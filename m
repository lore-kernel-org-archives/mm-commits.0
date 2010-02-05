From: akpm@linux-foundation.org
Subject: + maintainers-document-and-add-q-patchwork-queue-entries.patch added to -mm tree
Date: Fri, 05 Feb 2010 12:42:48 -0800
Message-ID: <201002052042.o15KgmT9020103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939Ab0BEUnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 15:43:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: document and add "Q" patchwork queue entries
has been added to the -mm tree.  Its filename is
     maintainers-document-and-add-q-patchwork-queue-entries.patch

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
@@ -236,6 +238,7 @@ ACPI
 M:	Len Brown <lenb@kernel.org>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
+Q:	http://patchwork.kernel.org/project/linux-acpi/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
 F:	drivers/acpi/
@@ -1335,6 +1338,7 @@ BTRFS FILE SYSTEM
 M:	Chris Mason <chris.mason@oracle.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
+Q:	http://patchwork.kernel.org/project/linux-btrfs/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
 S:	Maintained
 F:	Documentation/filesystems/btrfs.txt
@@ -1507,6 +1511,7 @@ M:	Steve French <sfrench@samba.org>
 L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
+Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/cifs.txt
@@ -1792,6 +1797,7 @@ DEVICE-MAPPER  (LVM)
 P:	Alasdair Kergon
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
+Q:	http://patchwork.kernel.org/project/dm-devel/list/
 S:	Maintained
 F:	Documentation/device-mapper/
 F:	drivers/md/dm*
@@ -2135,6 +2141,7 @@ M:	"Theodore Ts'o" <tytso@mit.edu>
 M:	Andreas Dilger <adilger@sun.com>
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
+Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
 S:	Maintained
 F:	Documentation/filesystems/ext4.txt
 F:	fs/ext4/
@@ -2698,6 +2705,7 @@ F:	drivers/scsi/ips.*
 IDE SUBSYSTEM
 M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-ide@vger.kernel.org
+Q:	http://patchwork.ozlabs.org/project/linux-ide/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
 S:	Maintained
 F:	Documentation/ide/
@@ -2752,6 +2760,7 @@ M:	Sean Hefty <sean.hefty@intel.com>
 M:	Hal Rosenstock <hal.rosenstock@gmail.com>
 L:	linux-rdma@vger.kernel.org
 W:	http://www.openib.org/
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 F:	Documentation/infiniband/
@@ -2771,6 +2780,7 @@ INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHS
 M:	Dmitry Torokhov <dmitry.torokhov@gmail.com>
 M:	Dmitry Torokhov <dtor@mail.ru>
 L:	linux-input@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-input/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
@@ -3093,6 +3103,7 @@ F:	drivers/hwmon/k8temp.c
 KCONFIG
 M:	Roman Zippel <zippel@linux-m68k.org>
 L:	linux-kbuild@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-kbuild/list/
 S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
@@ -3311,6 +3322,7 @@ M:	Benjamin Herrenschmidt <benh@kernel.c
 M:	Paul Mackerras <paulus@samba.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
+Q:	http://patchwork.ozlabs.org/project/linuxppc-dev/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
 S:	Supported
 F:	Documentation/powerpc/
@@ -3572,6 +3584,7 @@ M:	Mauro Carvalho Chehab <mchehab@infrad
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
+Q:	http://patchwork.kernel.org/project/linux-media/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/dvb/
@@ -3607,8 +3620,9 @@ F:	mm/memcontrol.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2@infradead.org>
-W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
+W:	http://www.linux-mtd.infradead.org/
+Q:	http://patchwork.ozlabs.org/project/linux-mtd/list/
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 F:	drivers/mtd/
@@ -3866,6 +3880,7 @@ S:	Maintained
 NETWORKING [WIRELESS]
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/mac80211/
@@ -3957,6 +3972,7 @@ M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
 W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
+Q:	http://patchwork.kernel.org/project/linux-omap/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
 S:	Maintained
 F:	arch/arm/*omap*/
@@ -4182,6 +4198,7 @@ M:	Helge Deller <deller@gmx.de>
 M:	"James E.J. Bottomley" <jejb@parisc-linux.org>
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
+Q:	http://patchwork.kernel.org/project/linux-parisc/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 S:	Maintained
 F:	arch/parisc/
@@ -4224,6 +4241,7 @@ F:	Documentation/powerpc/eeh-pci-error-r
 PCI SUBSYSTEM
 M:	Jesse Barnes <jbarnes@virtuousgeek.org>
 L:	linux-pci@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-pci/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
 F:	Documentation/PCI/
@@ -4601,6 +4619,7 @@ F:	include/linux/rtc.h
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
 L:	rtc-linux@googlegroups.com
+Q:	http://patchwork.ozlabs.org/project/rtc-linux/list/
 S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
@@ -4965,6 +4984,7 @@ F:	drivers/*/*/*s3c2410*
 TI DAVINCI MACHINE SUPPORT
 P:	Kevin Hilman
 M:	davinci-linux-open-source@linux.davincidsp.com
+Q:	http://patchwork.kernel.org/project/linux-davinci/list/
 S:	Supported
 F:	arch/arm/mach-davinci
 
@@ -5130,6 +5150,7 @@ F:	include/sound/soc*
 SPARC + UltraSPARC (sparc/sparc64)
 M:	"David S. Miller" <davem@davemloft.net>
 L:	sparclinux@vger.kernel.org
+Q:	http://patchwork.ozlabs.org/project/sparclinux/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
 S:	Maintained
@@ -5145,6 +5166,7 @@ SPI SUBSYSTEM
 M:	David Brownell <dbrownell@users.sourceforge.net>
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
+Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
 S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/
@@ -5221,6 +5243,7 @@ SUPERH
 M:	Paul Mundt <lethal@linux-sh.org>
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
+Q:	http://patchwork.kernel.org/project/linux-sh/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
 F:	Documentation/sh/
@@ -6187,6 +6210,7 @@ F:	drivers/serial/zs.*
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/LKML/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 S:	Buried alive in reporters
 F:	*
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
arch-ia64-fix-continuation-line-formats.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-staging-fix-continuation-line-formats.patch
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
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
maintainers-document-and-add-q-patchwork-queue-entries.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
checkpatch-warn-on-unnecessary-spaces-before-quoted-newlines.patch
scripts-checkpatchpl-dramatically-improve-define-parse-times.patch
drivers-hwmon-vt8231c-fix-continuation-line-formats.patch
drivers-video-via-fix-continuation-line-formats.patch

