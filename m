From: akpm@linux-foundation.org
Subject: - fix-ide-ide-remove-ide-dma-check.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:10 -0700
Message-ID: <200710051957.l95JvANP022444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763459AbXJEUB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fix ide-ide-remove-ide-dma-check
has been removed from the -mm tree.  Its filename was
     fix-ide-ide-remove-ide-dma-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix ide-ide-remove-ide-dma-check
From: Adrian Bunk <bunk@kernel.org>

static code mustn't be exported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-dma.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/ide/ide-dma.c~fix-ide-ide-remove-ide-dma-check drivers/ide/ide-dma.c
--- a/drivers/ide/ide-dma.c~fix-ide-ide-remove-ide-dma-check
+++ a/drivers/ide/ide-dma.c
@@ -787,8 +787,6 @@ static int ide_tune_dma(ide_drive_t *dri
 	return 1;
 }
 
-EXPORT_SYMBOL_GPL(ide_tune_dma);
-
 static int ide_dma_check(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
_

Patches currently in -mm which might be from bunk@kernel.org are

git-alsa.patch
git-arm.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-net.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-block.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
isdn-hisax-hfc_usbc-fix-check-after-use.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
