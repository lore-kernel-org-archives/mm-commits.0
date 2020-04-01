From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 31 Mar 2020 18:01:54 -0700
Message-ID: <20200401010154.WErrVl7_x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733083AbgDABBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Mar 2020 21:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/index.rst |    3 ---
 fs/io_uring.c                  |    4 ----
 include/linux/genhd.h          |    4 ----
 3 files changed, 11 deletions(-)

--- a/Documentation/kbuild/index.rst~linux-next-git-rejects
+++ a/Documentation/kbuild/index.rst
@@ -19,10 +19,7 @@ Kernel Build System
 
     issues
     reproducible-builds
-<<<<<<< HEAD
-=======
     llvm
->>>>>>> linux-next/akpm-base
     gcc-plugins
 
 .. only::  subproject and html
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -2743,11 +2743,7 @@ static int io_splice_prep(struct io_kioc
 
 static bool io_splice_punt(struct file *file)
 {
-<<<<<<< HEAD
-	if (get_pipe_info(file))
-=======
 	if (get_pipe_info(file, true))
->>>>>>> linux-next/akpm-base
 		return false;
 	if (!io_file_supports_async(file))
 		return true;
--- a/include/linux/genhd.h~linux-next-git-rejects
+++ a/include/linux/genhd.h
@@ -284,12 +284,8 @@ extern void disk_part_iter_init(struct d
 				 struct gendisk *disk, unsigned int flags);
 extern struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter);
 extern void disk_part_iter_exit(struct disk_part_iter *piter);
-<<<<<<< HEAD
-extern bool disk_has_partitions(struct gendisk *disk);
-=======
 
 bool disk_has_partitions(struct gendisk *disk);
->>>>>>> linux-next/akpm-base
 
 /* block/genhd.c */
 extern void device_add_disk(struct device *parent, struct gendisk *disk,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
drivers-net-ethernet-mellanox-mlx4-crdumpc-fix-build-with-gcc-720.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
