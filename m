From: akpm@linux-foundation.org
Subject: [merged] documentation-vm-makefile-dont-try-to-build-slqbinfo.patch removed from -mm tree
Date: Wed, 17 Jun 2009 16:15:07 -0700
Message-ID: <200906172315.n5HNF73q000640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755388AbZFQXPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 19:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, andi@firstfloor.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mpm@selenic.com, penberg@cs.helsinki.fi, mm


The patch titled
     Documentation/vm/Makefile: don't try to build slqbinfo
has been removed from the -mm tree.  Its filename was
     documentation-vm-makefile-dont-try-to-build-slqbinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/vm/Makefile: don't try to build slqbinfo
From: Andrew Morton <akpm@linux-foundation.org>

For it is only in linux-next at this stage.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/Makefile~documentation-vm-makefile-dont-try-to-build-slqbinfo Documentation/vm/Makefile
--- a/Documentation/vm/Makefile~documentation-vm-makefile-dont-try-to-build-slqbinfo
+++ a/Documentation/vm/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := slabinfo slqbinfo page-types
+hostprogs-y := slabinfo page-types
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
maintainers-fbdev-is-orphaned.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
char-moxa-prevent-opening-unavailable-ports.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-edac_device_alloc_index.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions.patch
lib-add-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

