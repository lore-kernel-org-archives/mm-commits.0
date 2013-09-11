From: akpm@linux-foundation.org
Subject: +
 partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch added to -mm tree
Date: Tue, 10 Sep 2013 17:21:32 -0700
Message-ID: <522fb78c.BRuX035CQ6NIS9HP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3IKAVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: + partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:21:32 -0700


The patch titled
     Subject: partitions-efi-use-lba-aware-partition-records-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: partitions-efi-use-lba-aware-partition-records-checkpatch-fixes

Cc: Davidlohr Bueso <davidlohr@hp.com>

ERROR: code indent should use tabs where possible
#40: FILE: block/partitions/efi.c:154:
+        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&$

WARNING: please, no spaces at the start of a line
#40: FILE: block/partitions/efi.c:154:
+        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&$

ERROR: code indent should use tabs where possible
#41: FILE: block/partitions/efi.c:155:
+            le32_to_cpu(part->start_sector) == 1UL)$

WARNING: please, no spaces at the start of a line
#41: FILE: block/partitions/efi.c:155:
+            le32_to_cpu(part->start_sector) == 1UL)$

WARNING: do not add new typedefs
#52: FILE: block/partitions/efi.h:104:
+typedef struct _gpt_record {

ERROR: code indent should use tabs where possible
#53: FILE: block/partitions/efi.h:105:
+        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */$

WARNING: please, no spaces at the start of a line
#53: FILE: block/partitions/efi.h:105:
+        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */$

ERROR: code indent should use tabs where possible
#54: FILE: block/partitions/efi.h:106:
+        u8      start_head;     /* unused by EFI, pt start in CHS */$

WARNING: please, no spaces at the start of a line
#54: FILE: block/partitions/efi.h:106:
+        u8      start_head;     /* unused by EFI, pt start in CHS */$

ERROR: code indent should use tabs where possible
#55: FILE: block/partitions/efi.h:107:
+        u8      start_sector;   /* unused by EFI, pt start in CHS */$

WARNING: please, no spaces at the start of a line
#55: FILE: block/partitions/efi.h:107:
+        u8      start_sector;   /* unused by EFI, pt start in CHS */$

ERROR: code indent should use tabs where possible
#56: FILE: block/partitions/efi.h:108:
+        u8      start_track;$

WARNING: please, no spaces at the start of a line
#56: FILE: block/partitions/efi.h:108:
+        u8      start_track;$

ERROR: code indent should use tabs where possible
#57: FILE: block/partitions/efi.h:109:
+        u8      os_type;        /* EFI and legacy non-EFI OS types */$

WARNING: please, no spaces at the start of a line
#57: FILE: block/partitions/efi.h:109:
+        u8      os_type;        /* EFI and legacy non-EFI OS types */$

ERROR: code indent should use tabs where possible
#58: FILE: block/partitions/efi.h:110:
+        u8      end_head;       /* unused by EFI, pt end in CHS */$

WARNING: please, no spaces at the start of a line
#58: FILE: block/partitions/efi.h:110:
+        u8      end_head;       /* unused by EFI, pt end in CHS */$

ERROR: code indent should use tabs where possible
#59: FILE: block/partitions/efi.h:111:
+        u8      end_sector;     /* unused by EFI, pt end in CHS */$

WARNING: please, no spaces at the start of a line
#59: FILE: block/partitions/efi.h:111:
+        u8      end_sector;     /* unused by EFI, pt end in CHS */$

ERROR: code indent should use tabs where possible
#60: FILE: block/partitions/efi.h:112:
+        u8      end_track;      /* unused by EFI, pt end in CHS */$

WARNING: please, no spaces at the start of a line
#60: FILE: block/partitions/efi.h:112:
+        u8      end_track;      /* unused by EFI, pt end in CHS */$

ERROR: code indent should use tabs where possible
#61: FILE: block/partitions/efi.h:113:
+        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */$

WARNING: please, no spaces at the start of a line
#61: FILE: block/partitions/efi.h:113:
+        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */$

ERROR: code indent should use tabs where possible
#62: FILE: block/partitions/efi.h:114:
+        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */$

WARNING: please, no spaces at the start of a line
#62: FILE: block/partitions/efi.h:114:
+        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */$

WARNING: __packed is preferred over __attribute__((packed))
#63: FILE: block/partitions/efi.h:115:
+} __attribute__ ((packed)) gpt_record;

total: 12 errors, 14 warnings, 40 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/partitions-efi-use-lba-aware-partition-records.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    6 +++---
 block/partitions/efi.h |   22 +++++++++++-----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-use-lba-aware-partition-records-checkpatch-fixes block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-use-lba-aware-partition-records-checkpatch-fixes
+++ a/block/partitions/efi.c
@@ -151,9 +151,9 @@ static u64 last_lba(struct block_device
 
 static inline int pmbr_part_valid(gpt_record *part)
 {
-        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
-            le32_to_cpu(part->start_sector) == 1UL)
-                return 1;
+	if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
+	    le32_to_cpu(part->start_sector) == 1UL)
+		return 1;
         return 0;
 }
 
diff -puN block/partitions/efi.h~partitions-efi-use-lba-aware-partition-records-checkpatch-fixes block/partitions/efi.h
--- a/block/partitions/efi.h~partitions-efi-use-lba-aware-partition-records-checkpatch-fixes
+++ a/block/partitions/efi.h
@@ -102,17 +102,17 @@ typedef struct _gpt_entry {
 } __attribute__ ((packed)) gpt_entry;
 
 typedef struct _gpt_record {
-        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */
-        u8      start_head;     /* unused by EFI, pt start in CHS */
-        u8      start_sector;   /* unused by EFI, pt start in CHS */
-        u8      start_track;
-        u8      os_type;        /* EFI and legacy non-EFI OS types */
-        u8      end_head;       /* unused by EFI, pt end in CHS */
-        u8      end_sector;     /* unused by EFI, pt end in CHS */
-        u8      end_track;      /* unused by EFI, pt end in CHS */
-        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */
-        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */
-} __attribute__ ((packed)) gpt_record;
+	u8	boot_indicator; /* unused by EFI, set to 0x80 for bootable */
+	u8	start_head;     /* unused by EFI, pt start in CHS */
+	u8	start_sector;   /* unused by EFI, pt start in CHS */
+	u8	start_track;
+	u8	os_type;        /* EFI and legacy non-EFI OS types */
+	u8	end_head;       /* unused by EFI, pt end in CHS */
+	u8	end_sector;     /* unused by EFI, pt end in CHS */
+	u8	end_track;      /* unused by EFI, pt end in CHS */
+	__le32	starting_lba;   /* used by EFI - start addr of the on disk pt */
+	__le32	size_in_lba;    /* used by EFI - size of pt in LBA */
+} __packed gpt_record;
 
 
 typedef struct _legacy_mbr {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
vfs-allow-umount-to-handle-mountpoints-without-revalidating-them-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

