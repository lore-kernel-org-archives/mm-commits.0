Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362DBC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 00:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiAMAr4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jan 2022 19:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiAMArx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jan 2022 19:47:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E689DC06173F
        for <mm-commits@vger.kernel.org>; Wed, 12 Jan 2022 16:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 856C161BBB
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 00:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF01FC36AE9;
        Thu, 13 Jan 2022 00:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642034871;
        bh=Q182pL44lLpoBah3etMV4RcxPns7qud+5UrFnWvgzww=;
        h=Date:From:To:Subject:From;
        b=otCD2boSb3sPsnBA5xs0Br8q7XwI3+v6nGshPOito3kBjvt51KKEyafGq+1HMWcI0
         CeIxYjTdV0dgW/1vBh5JdZvkeCOGzt1HYDyBQ2cllmO3F6W2dBrVczsm/U/GU/NGFY
         8fqq5elOkGk+UBXXAGdhdQjJ1zb8l6ebbiUVbbdo=
Date:   Wed, 12 Jan 2022 16:47:51 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20220113004751.1aUsezj61%akpm@linux-foundation.org>
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

 drivers/pinctrl/Kconfig |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/pinctrl/Kconfig~linux-next-git-rejects
+++ a/drivers/pinctrl/Kconfig
@@ -327,15 +327,6 @@ config PINCTRL_OXNAS
 	depends on OF
 	select PINMUX
 	select PINCONF
-<<<<<<< HEAD
-	select GPIOLIB_IRQCHIP
-
-config PINCTRL_STMFX
-	tristate "STMicroelectronics STMFX GPIO expander pinctrl driver"
-	depends on I2C
-	depends on OF_GPIO
-=======
->>>>>>> linux-next/akpm-base
 	select GENERIC_PINCONF
 	select GPIOLIB
 	select OF_GPIO
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
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
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

