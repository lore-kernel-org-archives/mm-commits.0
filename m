From: akpm@linux-foundation.org
Subject: + make-drivers-char-hvc_consoleckhvcd-static.patch added to -mm tree
Date: Mon, 04 Jun 2007 14:37:22 -0700
Message-ID: <200706042137.l54LbMdJ019769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbXFDVhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 17:37:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     make drivers/char/hvc_console.c:khvcd() static
has been added to the -mm tree.  Its filename is
     make-drivers-char-hvc_consoleckhvcd-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make drivers/char/hvc_console.c:khvcd() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_console.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hvc_console.c~make-drivers-char-hvc_consoleckhvcd-static drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~make-drivers-char-hvc_consoleckhvcd-static
+++ a/drivers/char/hvc_console.c
@@ -674,7 +674,7 @@ static const cpumask_t cpus_in_xmon = CP
  * calling hvc_poll() who determines whether a console adapter support
  * interrupts.
  */
-int khvcd(void *unused)
+static int khvcd(void *unused)
 {
 	int poll_mask;
 	struct hvc_struct *hp;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
the-async_-options-shouldnt-be-user-visible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
