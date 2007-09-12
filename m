From: akpm@linux-foundation.org
Subject: - update-gitignore.patch removed from -mm tree
Date: Tue, 11 Sep 2007 17:16:34 -0700
Message-ID: <200709120022.l8C0M8I0004594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbXILAWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 20:22:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     update .gitignore
has been removed from the -mm tree.  Its filename was
     update-gitignore.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: update .gitignore
From: Adrian Bunk <bunk@kernel.org>

Some shipped files were wrongly ignored by git.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN .gitignore~update-gitignore .gitignore
--- a/.gitignore~update-gitignore
+++ a/.gitignore
@@ -17,15 +17,21 @@
 *.lst
 *.symtypes
 
+# .gitignore files
+!.gitignore
+
 #
 # Top-level generic files
 #
 tags
 TAGS
 vmlinux*
-!vmlinux.lds.S
+!vmlinux*.lds*
+!vmlinux*.scr
 System.map
 Module.symvers
+!.mailmap
+!.mm
 
 #
 # Generated include files
_

Patches currently in -mm which might be from bunk@kernel.org are

update-gitignore.patch
fix-serial_core_console-driver-dependencies.patch
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
