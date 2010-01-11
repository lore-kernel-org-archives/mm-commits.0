From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-fixup.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:12:04 -0800
Message-ID: <201001112012.o0BKC4qP025021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754093Ab0AKUMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:12:25 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o0BKC5gB014686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 11 Jan 2010 12:12:06 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-fixup
has been removed from the -mm tree.  Its filename was
     linux-next-fixup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl/ioctl-number.txt |    1 +
 lib/Makefile                         |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/ioctl/ioctl-number.txt~linux-next-fixup Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~linux-next-fixup
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -292,6 +292,7 @@ Code  Seq#(hex)	Include File		Comments
 0x92	00-0F	drivers/usb/mon/mon_bin.c
 0x93	60-7F	linux/auto_fs.h
 0x94	all	fs/btrfs/ioctl.h
+0x97    00-7F   fs/ceph/ioctl.h         Ceph file system
 0x99	00-0F				537-Addinboard driver
 					<mailto:buk@buks.ipn.de>
 0xA0	all	linux/sdp/sdp.h		Industrial Device Project
diff -puN lib/Makefile~linux-next-fixup lib/Makefile
--- a/lib/Makefile~linux-next-fixup
+++ a/lib/Makefile
@@ -69,7 +69,7 @@ obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
 
 lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
-lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
+obj-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
 lib-$(CONFIG_DECOMPRESS_LZO) += decompress_unlzo.o
 
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

