From: akpm@linux-foundation.org
Subject: - mousedevcmixdev_open_devices-bugfix.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:37 -0700
Message-ID: <200708310634.l7V6YbRx027713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072AbXHaGer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     mousedev.c: mixdev_open_devices() bugfix
has been removed from the -mm tree.  Its filename was
     mousedevcmixdev_open_devices-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mousedev.c: mixdev_open_devices() bugfix
From: Adrian Bunk <bunk@kernel.org>

Fix an obvious bug in mixdev_open_devices().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mousedev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/mousedev.c~mousedevcmixdev_open_devices-bugfix drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~mousedevcmixdev_open_devices-bugfix
+++ a/drivers/input/mousedev.c
@@ -461,7 +461,7 @@ static void mixdev_open_devices(void)
 
 	list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
 		if (!mousedev->mixdev_open) {
-			if (mousedev_open_device(mousedev));
+			if (mousedev_open_device(mousedev))
 				continue;
 
 			mousedev->mixdev_open = 1;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
arm-extern-inline-static-inline.patch
ppc-remove-apus-support.patch
git-dvb.patch
ivtv-fbc-bugfix.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
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
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
