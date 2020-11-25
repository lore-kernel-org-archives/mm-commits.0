Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E422C56201
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 20:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C6D2075A
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 20:33:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d/X7vuKD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgKYUdJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 15:33:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:32946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgKYUdJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 15:33:09 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DCF9206F7;
        Wed, 25 Nov 2020 20:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606336388;
        bh=hTBiyhomEIUYir858sWS2UHVgvw8LoApXHv0vUtrDuk=;
        h=Date:From:To:Subject:From;
        b=d/X7vuKDnU+lRICHN4Sc0B0kVSpY909h02Aa0FfTHGbcmIF41gt02H2azys7yEtq+
         kMoHowdtMD6utdrLylDc2GaTx7vaqmE9HMXiORnKXgipGIjyueHMGohl5NuU4e3bx8
         iVaB7Ja+y7n4e61C7QJKNeuN/ehLwfphgJDbF0wY=
Date:   Wed, 25 Nov 2020 12:33:07 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20201125203307.vKXrVG72w%akpm@linux-foundation.org>
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

 drivers/media/platform/marvell-ccic/mmp-driver.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/media/platform/marvell-ccic/mmp-driver.c~linux-next-git-rejects
+++ a/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -308,11 +308,7 @@ static int mmpcam_platform_remove(struct
  */
 
 #ifdef CONFIG_PM
-<<<<<<< HEAD
-static int mmpcam_runtime_resume(struct device *dev)
-=======
 static int __maybe_unused mmpcam_runtime_resume(struct device *dev)
->>>>>>> linux-next/akpm-base
 {
 	struct mmp_camera *cam = dev_get_drvdata(dev);
 	struct mcam_camera *mcam = &cam->mcam;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

