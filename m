From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch removed from -mm tree
Date: Fri, 10 Apr 2009 02:19:25 -0700
Message-ID: <200904100919.n3A9JPPX012592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764466AbZDJJXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 05:23:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, adobriyan@gmail.com, ebiederm@aristanetworks.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-lockdep-support-for-sysctl-reference-counting-fix
has been removed from the -mm tree.  Its filename was
     sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl-lockdep-support-for-sysctl-reference-counting-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Biederman <ebiederm@aristanetworks.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-lockdep-support-for-sysctl-reference-counting-fix kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-lockdep-support-for-sysctl-reference-counting-fix
+++ a/kernel/sysctl.c
@@ -2072,7 +2072,7 @@ struct ctl_table_header *__register_sysc
 		return NULL;
 	}
 #endif
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#ifdef CONFIG_PROVE_LOCKING
 	{
 		static struct lock_class_key __key;
 		lockdep_init_map(&header->dep_map, "sysctl_used", &__key, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
hfs-fix-memory-leak-when-unmounting-fix.patch
memcg-remove-warning-when-config_debug_vm=n-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-consolidate-init_mm-definition-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

