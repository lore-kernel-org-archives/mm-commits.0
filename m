From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 05 May 2015 15:28:55 -0700
Message-ID: <55494427.1ZLaCKnJ1tx/c/Dk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbbEEW24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 18:28:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/platform/marvell-ccic/mcam-core.c |    7 -------
 include/soc/tegra/emc.h                         |    4 ----
 2 files changed, 11 deletions(-)

diff -puN drivers/media/platform/marvell-ccic/mcam-core.c~linux-next-git-rejects drivers/media/platform/marvell-ccic/mcam-core.c
--- a/drivers/media/platform/marvell-ccic/mcam-core.c~linux-next-git-rejects
+++ a/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -772,13 +772,6 @@ static void mcam_ctlr_image(struct mcam_
 	case V4L2_PIX_FMT_YUYV:
 		mcam_reg_write_mask(cam, REG_CTRL0,
 			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_NOSWAP, C0_DF_MASK);
-<<<<<<< HEAD
-		break;
-	case V4L2_PIX_FMT_YVYU:
-		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_SWAP24, C0_DF_MASK);
-=======
->>>>>>> linux-next/akpm-base
 		break;
 	case V4L2_PIX_FMT_YVYU:
 		mcam_reg_write_mask(cam, REG_CTRL0,
diff -puN include/soc/tegra/emc.h~linux-next-git-rejects include/soc/tegra/emc.h
--- a/include/soc/tegra/emc.h~linux-next-git-rejects
+++ a/include/soc/tegra/emc.h
@@ -1,9 +1,5 @@
 /*
-<<<<<<< HEAD
- * Copyright (c) 2014 NVIDIA Corporation. All rights reserved.
-=======
  * Copyright (C) 2014 NVIDIA Corporation
->>>>>>> e45edb177253... memory: tegra: Add EMC (external memory controller) driver
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
maintainers-add-co-maintainer-for-led-subsystem.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

