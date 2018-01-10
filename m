From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Wed, 10 Jan 2018 11:49:59 -0800
Message-ID: <20180110194959.xVe3icp2y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeAJTuB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jan 2018 14:50:01 -0500
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


diff -puN drivers/infiniband/ulp/srpt/ib_srpt.c~linux-next-git-rejects drivers/infiniband/ulp/srpt/ib_srpt.c
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c~linux-next-git-rejects
+++ a/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2126,15 +2126,8 @@ static int srpt_cm_req_recv(struct ib_cm
 		goto destroy_ib;
 	}
 
-<<<<<<< HEAD
-	guid = (__be16 *)&param->primary_path->dgid.global.interface_id;
-	snprintf(ch->ini_guid, sizeof(ch->ini_guid), "%04x:%04x:%04x:%04x",
-		 be16_to_cpu(guid[0]), be16_to_cpu(guid[1]),
-		 be16_to_cpu(guid[2]), be16_to_cpu(guid[3]));
-=======
 	srpt_format_guid(ch->ini_guid, sizeof(ch->ini_guid),
 			 &param->primary_path->dgid.global.interface_id);
->>>>>>> linux-next/akpm-base
 	snprintf(ch->sess_name, sizeof(ch->sess_name), "0x%016llx%016llx",
 			be64_to_cpu(*(__be64 *)ch->i_port_id),
 			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

