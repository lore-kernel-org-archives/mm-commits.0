From: akpm@linux-foundation.org
Subject: - maintainers-corrections.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:33 -0700
Message-ID: <200706121857.l5CIvXpq018482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42251 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbXFLTE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: corrections
has been removed from the -mm tree.  Its filename was
     maintainers-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINERS: corrections
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The UFS entry was misformatted
The NEC V850 links are all broken
The Berkshire watchdog links are all broken

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff -puN MAINTAINERS~maintainers-corrections MAINTAINERS
--- a/MAINTAINERS~maintainers-corrections
+++ a/MAINTAINERS
@@ -782,11 +782,6 @@ M:	rathamahata@php4.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-BERKSHIRE PRODUCTS PC WATCHDOG DRIVER
-P:	Kenji Hollis
-W:	http://ftp.bitgate.com/pcwd/
-S:	Maintained
-
 BFS FILE SYSTEM
 P:	Tigran A. Aivazian
 M:	tigran@aivazian.fsnet.co.uk
@@ -3904,10 +3899,6 @@ S:	Maintained
 
 UCLINUX FOR NEC V850
 P:	Miles Bader
-M:	uclinux-v850@lsi.nec.co.jp
-W:	http://www.ic.nec.co.jp/micro/uclinux/eng/
-W:	http://www.ee.nec.de/uclinux/
-S:	Supported
 
 UCLINUX FOR RENESAS H8/300
 P:	Yoshinori Sato
@@ -3916,10 +3907,10 @@ W:	http://uclinux-h8.sourceforge.jp/
 S:	Supported
 
 UFS FILESYSTEM
-P: Evgeniy Dushistov
-M: dushistov@mail.ru
-L: linux-kernel@vger.kernel.org
-S: Maintained
+P:	Evgeniy Dushistov
+M:	dushistov@mail.ru
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
 
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty-restore-locked-ioctl-file-op.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
add-pci_try_set_mwi-prism54pci.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
audit-add-tty-input-auditing-fix.patch
revert-vanishing-ioctl-handler-debugging.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
