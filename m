Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B11AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 20 Sep 2021 23:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D9761252
	for <mm-commits@archiver.kernel.org>; Mon, 20 Sep 2021 23:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbhITXwE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Sep 2021 19:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234242AbhITXuE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Sep 2021 19:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2280261245;
        Mon, 20 Sep 2021 23:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632181717;
        bh=AE+yGIV62of6h/y6PQpa1V8RjGBQZPFf1TBJchnEZUw=;
        h=Date:From:To:Subject:From;
        b=iEnnhIpWeIWmRm4QntATmQ3GPTYPXpGrYo3c8CILfgwIQDhCGYDBdJgLieNg19JfP
         Vea/sOq8LhRh/X+CKrp1x5RQz+FAfHtvgxX1a0YHxksybXtV1xrRVf6R96k9wr+oF1
         xZNVNEIu+Ic/BncRf+EXhTu6UoImyHcTicI/yztU=
Date:   Mon, 20 Sep 2021 16:48:36 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210920234836.DInWZIMvN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

