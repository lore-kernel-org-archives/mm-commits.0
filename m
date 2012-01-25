From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 25 Jan 2012 12:40:41 -0800
Message-ID: <20120125204045.A89DFA02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:64512 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2AYUkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 15:40:47 -0500
Received: by qcsd17 with SMTP id d17so505714qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 12:40:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN sound/pci/hda/hda_intel.c~linux-next-git-rejects sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~linux-next-git-rejects
+++ a/sound/pci/hda/hda_intel.c
@@ -2776,11 +2776,6 @@ static int __devinit azx_create(struct s
 	}
 
 	/* disable buffer size rounding to 128-byte multiples if supported */
-<<<<<<< HEAD
-	chip->align_buffer_size = align_buffer_size;
-	if (chip->driver_caps & AZX_DCAPS_BUFSIZE)
-		chip->align_buffer_size = 0;
-=======
 	if (align_buffer_size >= 0)
 		chip->align_buffer_size = !!align_buffer_size;
 	else {
@@ -2791,7 +2786,6 @@ static int __devinit azx_create(struct s
 		else
 			chip->align_buffer_size = 1;
 	}
->>>>>>> linux-next/akpm-end
 
 	/* allow 64bit DMA address if supported by H/W */
 	if ((gcap & ICH6_GCAP_64OK) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

