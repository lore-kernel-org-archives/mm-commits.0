Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841D4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 21:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhLUVSz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 16:18:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58580 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhLUVSy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 16:18:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D6D4CE1A6F
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 21:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B964DC36AE9;
        Tue, 21 Dec 2021 21:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640121531;
        bh=L+5Kmwz9fZaSg5Aw7I8UYff2bsN71QzSA17gcSnhrnQ=;
        h=Date:From:To:Subject:From;
        b=egXokBN0Mc3VCBaiKAW+0blVCfUx25hk5/Fdb8mzcdyZYXyyVVM/eTWi5MRBQhVL8
         lBIvG5aejx6DQrjJxpXdl2jB3jPipVY9z6OtHYL6r4/5FaZDysa73GUcX59iOT41A4
         K9Rnn10poRzIe2HRcNreO7IV1rKHOEu7cnLEZFXY=
Date:   Tue, 21 Dec 2021 13:18:51 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete]
 drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch removed from -mm tree
Message-ID: <20211221211851.CTe3HZbcG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/vmwgfx/vmwgfx_gem.c: printk fix
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/gpu/drm/vmwgfx/vmwgfx_gem.c: printk fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c~drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -227,7 +227,7 @@ static void vmw_bo_print_info(int id, st
 		break;
 	}
 
-	seq_printf(m, "\t\t0x%08x: %12ld bytes %s, type = %s",
+	seq_printf(m, "\t\t0x%08x: %12zd bytes %s, type = %s",
 		   id, bo->base.base.size, placement, type);
 	seq_printf(m, ", priority = %u, pin_count = %u, GEM refs = %d, TTM refs = %d",
 		   bo->base.priority,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

