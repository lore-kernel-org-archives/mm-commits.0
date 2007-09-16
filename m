From: akpm@linux-foundation.org
Subject: - net-sctp-socketc-make-3-variables-static.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:19 -0700
Message-ID: <200709160927.l8G9RJRQ009250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbXIPJjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, davem@davemloft.net, nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     net/sctp/socket.c: make 3 variables static
has been removed from the -mm tree.  Its filename was
     net-sctp-socketc-make-3-variables-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/sctp/socket.c: make 3 variables static
From: Adrian Bunk <bunk@kernel.org>

Makethe following needlessly global variables static:

- sctp_memory_pressure
- sctp_memory_allocated
- sctp_sockets_allocated

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/sctp/socket.c~net-sctp-socketc-make-3-variables-static net/sctp/socket.c
--- a/net/sctp/socket.c~net-sctp-socketc-make-3-variables-static
+++ a/net/sctp/socket.c
@@ -112,9 +112,9 @@ extern int sysctl_sctp_mem[3];
 extern int sysctl_sctp_rmem[3];
 extern int sysctl_sctp_wmem[3];
 
-int sctp_memory_pressure;
-atomic_t sctp_memory_allocated;
-atomic_t sctp_sockets_allocated;
+static int sctp_memory_pressure;
+static atomic_t sctp_memory_allocated;
+static atomic_t sctp_sockets_allocated;
 
 static void sctp_enter_memory_pressure(void)
 {
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
