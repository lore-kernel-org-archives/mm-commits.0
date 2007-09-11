From: akpm@linux-foundation.org
Subject: - au88x0_synthc-bugfix.patch removed from -mm tree
Date: Tue, 11 Sep 2007 13:20:33 -0700
Message-ID: <200709112020.l8BKKYfF027720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934196AbXIKUVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 16:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     au88x0_synth.c bugfix
has been removed from the -mm tree.  Its filename was
     au88x0_synthc-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: au88x0_synth.c bugfix
From: Adrian Bunk <bunk@kernel.org>

This patch fixes the code in vortex_wt_SetFrequency() to what seems to
have been intended.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/au88x0/au88x0_synth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/pci/au88x0/au88x0_synth.c~au88x0_synthc-bugfix sound/pci/au88x0/au88x0_synth.c
--- a/sound/pci/au88x0/au88x0_synth.c~au88x0_synthc-bugfix
+++ a/sound/pci/au88x0/au88x0_synth.c
@@ -370,8 +370,8 @@ static void vortex_wt_SetFrequency(vorte
 			while ((edx & 0x80000000) == 0) {
 				edx <<= 1;
 				eax--;
-				if (eax == 0) ;
-				break;
+				if (eax == 0)
+					break;
 			}
 			if (eax)
 				edx <<= 1;
_

Patches currently in -mm which might be from bunk@kernel.org are

update-gitignore.patch
git-alsa.patch
arm-extern-inline-static-inline.patch
omap1-leds-innovatorc-remove-dead-code.patch
ppc-remove-apus-support.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
fix-serial_core_console-driver-dependencies.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
kconfig-syntax-cleanups.patch
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
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
