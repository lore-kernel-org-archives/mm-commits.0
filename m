From: akpm@linux-foundation.org
Subject: [folded] memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:18:40 -0800
Message-ID: <201003052118.o25LIeMI028158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab0CEVSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:18:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, fengguang.wu@intel.com, haveblue@us.ibm.com, shaohui.zheng@intel.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch

This patch was dropped because it was folded into memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix
From: Andrew Morton <akpm@linux-foundation.org>

un-kernedoc a no longer kerneldoc comment

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/memmap.c~memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix
+++ a/drivers/firmware/memmap.c
@@ -122,7 +122,7 @@ static int firmware_map_add_entry(u64 st
 	return 0;
 }
 
-/**
+/*
  * Add memmap entry on sysfs
  */
 static int add_sysfs_fw_map_entry(struct firmware_map_entry *entry)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

