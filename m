Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14110C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B776623601
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbhAGWeh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 17:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbhAGWeh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 17:34:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A559235FD;
        Thu,  7 Jan 2021 22:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610058836;
        bh=cfoCOJSDia/Wd3UUy2Y3wHxXGx6sbaeMqERuoNx8+/8=;
        h=Date:From:To:Subject:From;
        b=f0uwYeL4Un5R/UYfQAmW6aj60fPUPbtpJqgwOCPCIxWXtxVt57YYHfnqiat2JyIv4
         l1XOU/lICrAZZWwmhUb64Gwb9tStfeMKcVjehL38mHEUZRDuRC6zTIegfCUfH/trPl
         1AJkwgzYkJkd2y06L/fCYJuVEaF5WosF5jwuWhCs=
Date:   Thu, 07 Jan 2021 14:33:56 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210107223356.GZcRCTmDU%akpm@linux-foundation.org>
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

 drivers/regulator/qcom-rpmh-regulator.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/regulator/qcom-rpmh-regulator.c~linux-next-git-rejects
+++ a/drivers/regulator/qcom-rpmh-regulator.c
@@ -727,8 +727,6 @@ static const struct rpmh_vreg_hw_data pm
 	.regulator_type = VRM,
 	.ops = &rpmh_regulator_vrm_ops,
 	.voltage_range = REGULATOR_LINEAR_RANGE(2800000, 0, 4, 16000),
-<<<<<<< HEAD
-=======
 	.n_voltages = 5,
 	.pmic_mode_map = pmic_mode_map_pmic5_smps,
 	.of_map_mode = rpmh_regulator_pmic4_smps_of_map_mode,
@@ -738,7 +736,6 @@ static const struct rpmh_vreg_hw_data pm
 	.regulator_type = VRM,
 	.ops = &rpmh_regulator_vrm_ops,
 	.voltage_range = REGULATOR_LINEAR_RANGE(900000, 0, 4, 16000),
->>>>>>> linux-next/akpm-base
 	.n_voltages = 5,
 	.pmic_mode_map = pmic_mode_map_pmic5_smps,
 	.of_map_mode = rpmh_regulator_pmic4_smps_of_map_mode,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

