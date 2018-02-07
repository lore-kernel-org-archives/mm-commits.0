From: akpm@linux-foundation.org
Subject: [merged] lib-ubsanc-s-missaligned-misaligned.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:59:07 -0800
Message-ID: <20180207195907.gmlDHbjy8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60194 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754411AbeBGT7I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, David.Laight@ACULAB.COM, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ubsan.c: s/missaligned/misaligned/
has been removed from the -mm tree.  Its filename was
     lib-ubsanc-s-missaligned-misaligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/ubsan.c: s/missaligned/misaligned/

A vist from the spelling fairy.

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/ubsan.c~lib-ubsanc-s-missaligned-misaligned lib/ubsan.c
--- a/lib/ubsan.c~lib-ubsanc-s-missaligned-misaligned
+++ a/lib/ubsan.c
@@ -281,7 +281,7 @@ static void handle_null_ptr_deref(struct
 	ubsan_epilogue(&flags);
 }
 
-static void handle_missaligned_access(struct type_mismatch_data *data,
+static void handle_misaligned_access(struct type_mismatch_data *data,
 				unsigned long ptr)
 {
 	unsigned long flags;
@@ -322,7 +322,7 @@ void __ubsan_handle_type_mismatch(struct
 	if (!ptr)
 		handle_null_ptr_deref(data);
 	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment))
-		handle_missaligned_access(data, ptr);
+		handle_misaligned_access(data, ptr);
 	else
 		handle_object_size_mismatch(data, ptr);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

