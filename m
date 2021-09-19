Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F137C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 18:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F34860FA0
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 18:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhISSOs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 14:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISSOq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 14:14:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17F5360F9B;
        Sun, 19 Sep 2021 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632075201;
        bh=E9PEgdHGxEJ4XJU5cgPRe3BARxOn8bmdYyrum7dgL0k=;
        h=Date:From:To:Subject:From;
        b=hHhbQfEXWuXTDiLAXSAfv8xpYofSMqBZMm3Iku9/V3GITOx3fNGvzpEO4l2Ysl8T4
         DAHHw1aoEb1EZHhVfqQCz0lxKw79f84mI8UrYkJfoC6EhmLcaM+O/MpTWinjsoR2Vf
         rjYpIKVd10sdormhglMw+x861BIdZJgEhSjmCPmg=
Date:   Sun, 19 Sep 2021 11:13:20 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210919181320.NUrPu5U2W%akpm@linux-foundation.org>
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

 drivers/spi/spi-tegra20-slink.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/spi/spi-tegra20-slink.c~linux-next-git-rejects
+++ a/drivers/spi/spi-tegra20-slink.c
@@ -1182,12 +1182,8 @@ static int tegra_slink_resume(struct dev
 }
 #endif
 
-<<<<<<< HEAD
-static int __maybe_unused tegra_slink_runtime_suspend(struct device *dev)
-=======
 #ifdef CONFIG_PM
 static int tegra_slink_runtime_suspend(struct device *dev)
->>>>>>> linux-next/akpm-base
 {
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

