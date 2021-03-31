Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8453BC433B4
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 20:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D1A60BBB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 20:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhCaU5b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhCaU5N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 16:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EA6761056;
        Wed, 31 Mar 2021 20:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617224233;
        bh=lSgUGDeZ29y4qhzACclGLwM+7u/NzOl9JEDqRe7PkHQ=;
        h=Date:From:To:Subject:From;
        b=y98oQajgjdGxFcsPMWCejvhaLmQrL4FfbyQVqWAJAuPToWOikg0s9+aYeBLGcNM7Y
         OROdHNpm5qJ8+68s75c8GeZdfs7VTntY235tZKK3OxRR+uKtAtzfjtcN07nvzCxiJW
         BP1lgHgLxFy/JQCLLTVPaHltJ5BLMWCB2v+frmO8=
Date:   Wed, 31 Mar 2021 13:57:12 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210331205712.V8hwvjFJl%akpm@linux-foundation.org>
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

 drivers/pinctrl/qcom/pinctrl-sc7280.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-sc7280.c~linux-next-git-rejects
+++ a/drivers/pinctrl/qcom/pinctrl-sc7280.c
@@ -1447,8 +1447,6 @@ static const struct msm_pingroup sc7280_
 	[180] = SDC_QDSD_PINGROUP(sdc2_clk, 0xb4000, 14, 6),
 	[181] = SDC_QDSD_PINGROUP(sdc2_cmd, 0xb4000, 11, 3),
 	[182] = SDC_QDSD_PINGROUP(sdc2_data, 0xb4000, 9, 0),
-<<<<<<< HEAD
-=======
 };
 
 static const struct msm_gpio_wakeirq_map sc7280_pdc_map[] = {
@@ -1471,7 +1469,6 @@ static const struct msm_gpio_wakeirq_map
 	{ 150, 87 }, { 151, 88 }, { 153, 89 }, { 155, 164 }, { 156, 129 },
 	{ 157, 161 }, { 158, 120 }, { 161, 136 }, { 163, 142 }, { 172, 166 },
 	{ 174, 167 },
->>>>>>> linux-next/akpm-base
 };
 
 static const struct msm_pinctrl_soc_data sc7280_pinctrl = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

