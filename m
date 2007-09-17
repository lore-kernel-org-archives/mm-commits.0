From: akpm@linux-foundation.org
Subject: - pass-g-to-assembler-under-config_debug_info-fix.patch removed from -mm tree
Date: Mon, 17 Sep 2007 03:15:59 -0700
Message-ID: <200709171015.l8HAFx7i007054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437AbXIQKQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Sep 2007 06:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, jason.wessel@windriver.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFLAGS: fix the -g setting
has been removed from the -mm tree.  Its filename was
     pass-g-to-assembler-under-config_debug_info-fix.patch

This patch was dropped because Sam changed the Makefile a lot

------------------------------------------------------
Subject: AFLAGS: fix the -g setting
From: Adrian Bunk <bunk@kernel.org>

It's -gdwarf-2, not -gdwarf2. With this fix it can actually work.

And since even gcc 3.2 supports -gdwarf-2 there's no reason for checking
with as-option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~pass-g-to-assembler-under-config_debug_info-fix Makefile
--- a/Makefile~pass-g-to-assembler-under-config_debug_info-fix
+++ a/Makefile
@@ -499,7 +499,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 CFLAGS		+= -g
-AFLAGS		+= $(call as-option, -gdwarf2)
+AFLAGS		+= -gdwarf-2
 endif
 
 # Force gcc to behave correct even for buggy distributions
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
