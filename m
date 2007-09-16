From: akpm@linux-foundation.org
Subject: - fix-serial_core_console-driver-dependencies.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:32 -0700
Message-ID: <200709160926.l8G9QWPQ009190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbXIPJim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bryan.wu@analog.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix SERIAL_CORE_CONSOLE driver dependencies
has been removed from the -mm tree.  Its filename was
     fix-serial_core_console-driver-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix SERIAL_CORE_CONSOLE driver dependencies
From: Adrian Bunk <bunk@kernel.org>

SERIAL_BFIN=m or SERIAL_MUX=m shouldn't allow SERIAL_CORE_CONSOLE=y.

Additionally, this patch fixes whitespace instead of tabs at the
SERIAL_MUX_CONSOLE option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/serial/Kconfig~fix-serial_core_console-driver-dependencies drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~fix-serial_core_console-driver-dependencies
+++ a/drivers/serial/Kconfig
@@ -611,7 +611,7 @@ config SERIAL_BFIN
 
 config SERIAL_BFIN_CONSOLE
 	bool "Console on Blackfin serial port"
-	depends on SERIAL_BFIN
+	depends on SERIAL_BFIN=y
 	select SERIAL_CORE_CONSOLE
 
 choice
@@ -832,10 +832,10 @@ config SERIAL_MUX
 	    4. Change the kernel command console parameter to: console=ttyB0
 
 config SERIAL_MUX_CONSOLE
-        bool "Support for console on serial MUX"
-        depends on SERIAL_MUX
+	bool "Support for console on serial MUX"
+	depends on SERIAL_MUX=y
 	select SERIAL_CORE_CONSOLE
-        default y
+	default y
 
 config PDC_CONSOLE
 	bool "PDC software console support"
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-alsa.patch
git-arm.patch
ppc-remove-apus-support.patch
powerpc-proper-defconfig-for-crosscompiles.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
git-net.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-block.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
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
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
