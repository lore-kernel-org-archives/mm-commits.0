From: akpm@linux-foundation.org
Subject: [folded] firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:31:10 -0700
Message-ID: <20120730213111.6CD08A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:50340 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2G3VbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:31:13 -0400
Received: by obbwc20 with SMTP id wc20so4013245obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:31:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, mingo@kernel.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix
has been removed from the -mm tree.  Its filename was
     firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch

This patch was dropped because it was folded into firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix

clarify comments

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/memmap.c~firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix
+++ a/drivers/firmware/memmap.c
@@ -98,7 +98,7 @@ static LIST_HEAD(map_entries);
 /**
  * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
  * @start: Start of the memory range.
- * @end:   End of the memory range.
+ * @end:   End of the memory range (exclusive).
  * @type:  Type of the memory range.
  * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
  *         entry.
@@ -148,7 +148,7 @@ static int add_sysfs_fw_map_entry(struct
  * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
  * memory hotplug.
  * @start: Start of the memory range.
- * @end:   End of the memory range.
+ * @end:   End of the memory range (exclusive)
  * @type:  Type of the memory range.
  *
  * Adds a firmware mapping entry. This function is for memory hotplug, it is
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
minixfs-fix-block-limit-check.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

