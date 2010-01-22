From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 22 Jan 2010 12:35:02 -0800
Message-ID: <201001222035.o0MKZ2Hg026233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947Ab0AVUfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 15:35:06 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o0MKZ3dQ007609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 22 Jan 2010 12:35:04 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c    |   16 ----------------
 drivers/usb/core/sysfs.c |    4 ----
 2 files changed, 20 deletions(-)

diff -puN lib/zlib_inflate/inffast.c~linux-next-git-rejects lib/zlib_inflate/inffast.c
diff -puN drivers/base/memory.c~linux-next-git-rejects drivers/base/memory.c
--- a/drivers/base/memory.c~linux-next-git-rejects
+++ a/drivers/base/memory.c
@@ -309,12 +309,8 @@ static SYSDEV_ATTR(removable, 0444, show
  * Block size attribute stuff
  */
 static ssize_t
-<<<<<<< HEAD:drivers/base/memory.c
-print_block_size(struct class *class, char *buf)
-=======
 print_block_size(struct sysdev_class *class, struct sysdev_class_attribute *attr,
 		 char *buf)
->>>>>>> FETCH_HEAD:drivers/base/memory.c
 {
 	return sprintf(buf, "%#lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
 }
@@ -335,12 +331,8 @@ static int block_size_init(void)
  */
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 static ssize_t
-<<<<<<< HEAD:drivers/base/memory.c
-memory_probe_store(struct class *class, const char *buf, size_t count)
-=======
 memory_probe_store(struct class *class, struct class_attribute *attr,
 		   const char *buf, size_t count)
->>>>>>> FETCH_HEAD:drivers/base/memory.c
 {
 	u64 phys_addr;
 	int nid;
@@ -377,13 +369,9 @@ static inline int memory_probe_init(void
 
 /* Soft offline a page */
 static ssize_t
-<<<<<<< HEAD:drivers/base/memory.c
-store_soft_offline_page(struct class *class, const char *buf, size_t count)
-=======
 store_soft_offline_page(struct class *class,
 			struct class_attribute *attr,
 			const char *buf, size_t count)
->>>>>>> FETCH_HEAD:drivers/base/memory.c
 {
 	int ret;
 	u64 pfn;
@@ -400,13 +388,9 @@ store_soft_offline_page(struct class *cl
 
 /* Forcibly offline a page, including killing processes. */
 static ssize_t
-<<<<<<< HEAD:drivers/base/memory.c
-store_hard_offline_page(struct class *class, const char *buf, size_t count)
-=======
 store_hard_offline_page(struct class *class,
 			struct class_attribute *attr,
 			const char *buf, size_t count)
->>>>>>> FETCH_HEAD:drivers/base/memory.c
 {
 	int ret;
 	u64 pfn;
diff -puN drivers/usb/core/sysfs.c~linux-next-git-rejects drivers/usb/core/sysfs.c
--- a/drivers/usb/core/sysfs.c~linux-next-git-rejects
+++ a/drivers/usb/core/sysfs.c
@@ -115,11 +115,7 @@ show_speed(struct device *dev, struct de
 	case USB_SPEED_HIGH:
 		speed = "480";
 		break;
-<<<<<<< HEAD:drivers/usb/core/sysfs.c
-	case USB_SPEED_VARIABLE:
-=======
 	case USB_SPEED_WIRELESS:
->>>>>>> FETCH_HEAD:drivers/usb/core/sysfs.c
 		speed = "480";
 		break;
 	case USB_SPEED_SUPER:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

