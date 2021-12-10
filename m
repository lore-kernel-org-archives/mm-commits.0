Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E6EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 16:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbhLJQm3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 11:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243822AbhLJQm3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 11:42:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B483AC0617A1
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 08:38:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B4C2CE2BE2
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 16:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DD3C341C5;
        Fri, 10 Dec 2021 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639154330;
        bh=wg9qQlGdUpVR3l1TKGFOMKOZW6XuA+MScmKzjdyyqWc=;
        h=Date:From:To:Subject:From;
        b=H1oZE1xZZ8Nk2UaARPsPAnyo6xE33dNZqQtNMqrt5jFi2YBq7ek4buvyIUhKtKlWW
         Ie7btqYOhNrMo7WRnNvdMpASokVxNsN1dTpSfDrl+YZ3XhQdVb5k/WPu2nmmaJlfSH
         8fZT9j83Q/3hopxnUKhKAh1Vi+mL7KOQRIhdd4xU=
Date:   Fri, 10 Dec 2021 08:38:49 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20211210163849.OgpNbp6Hb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gt/intel_gtt.c |    3 ---
 kernel/bpf/btf.c                    |    3 ---
 2 files changed, 6 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_gtt.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gt/intel_gtt.c
@@ -7,11 +7,8 @@
 
 #include <linux/fault-inject.h>
 #include <linux/sched/mm.h>
-<<<<<<< HEAD
-=======
 
 #include <drm/drm_cache.h>
->>>>>>> linux-next/akpm-base
 
 #include "gem/i915_gem_lmem.h"
 #include "i915_trace.h"
--- a/kernel/bpf/btf.c~linux-next-git-rejects
+++ a/kernel/bpf/btf.c
@@ -6410,8 +6410,6 @@ DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfun
 DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
 
 #endif
-<<<<<<< HEAD
-=======
 
 int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
 			      const struct btf *targ_btf, __u32 targ_id)
@@ -6794,4 +6792,3 @@ out:
 	}
 	return err;
 }
->>>>>>> linux-next/akpm-base
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

