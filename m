From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 15:18:55 -0800
Message-ID: <20121218231856.2F8A520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:65122 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2LRXS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:18:59 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so69371fav.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:18:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe.jin@oracle.com, khali@linux-fr.org, zhenzhong.duan@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix
has been removed from the -mm tree.  Its filename was
     drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch

This patch was dropped because it was folded into drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix

tweak code comment

Cc: Feng Jin <joe.jin@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix
+++ a/drivers/firmware/dmi_scan.c
@@ -16,7 +16,7 @@
  */
 static char dmi_empty_string[] = "        ";
 
-static u16  __initdata dmi_ver;
+static u16 __initdata dmi_ver;
 /*
  * Catch too early calls to dmi_check_system():
  */
@@ -176,11 +176,10 @@ static void __init dmi_save_uuid(const s
 		return;
 
 	/*
-	 * As of version 2.6 of the SMBIOS specification, the first 3
-	 * fields of the UUID are supposed to be encoded on little-endian.
-	 * The specification says that this is the defacto standard,
-	 * update kernel code to match dmidecode data.
-	*/
+	 * As of version 2.6 of the SMBIOS specification, the first 3 fields of
+	 * the UUID are supposed to be little-endian encoded.  The specification
+	 * says that this is the defacto standard.
+	 */
 	if (dmi_ver >= 0x0206)
 		sprintf(s, "%pUL", d);
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sendfile-allows-bypassing-of-notifier-events.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

