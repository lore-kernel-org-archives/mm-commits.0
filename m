From: akpm@linux-foundation.org
Subject: [folded] btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:23:18 -0700
Message-ID: <20120730212318.EA0A51E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64700 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3VXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:23:19 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4007822obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:23:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix
has been removed from the -mm tree.  Its filename was
     btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch

This patch was dropped because it was folded into btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix

whitespace tweak.  checkpatch bug ;)

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/btrfs/super.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix fs/btrfs/super.c
--- a/fs/btrfs/super.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix
+++ a/fs/btrfs/super.c
@@ -192,7 +192,7 @@ void btrfs_printk(struct btrfs_fs_info *
 
 	kern_level = printk_get_level(fmt);
 	if (kern_level) {
-		size_t size = printk_skip_level(fmt)  - fmt;
+		size_t size = printk_skip_level(fmt) - fmt;
 		memcpy(lvl, fmt,  size);
 		lvl[size] = '\0';
 		fmt += size;
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
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
minixfs-fix-block-limit-check-fix.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

