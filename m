Return-Path: <SRS0=4Ckc=BQ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7D3C433DF
	for <mm-commits@archiver.kernel.org>; Thu,  6 Aug 2020 23:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A2E92075A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Aug 2020 23:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596755927;
	bh=m88QXL84fHnNCN8r5Kr47Ai8eS90mAx0qYDYC7QDGDQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hNj2NiT8lUMeojdkwiR1aneA0HlR26lHpJa298IUl9So2K6/1zxtZB0U1BCHq3rh4
	 EvYhfV0iDLb/ypgkqh3dHqxpuQZu36yn4zjSzWCa06B0ito8kwYTz75WhOfjM4fny5
	 GrxiFuyU2rbdTzrn3xLNNqYvpxUL76SGQ2e1sX6g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgHFXSq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Aug 2020 19:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgHFXSq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 Aug 2020 19:18:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F762075A;
        Thu,  6 Aug 2020 23:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596755926;
        bh=m88QXL84fHnNCN8r5Kr47Ai8eS90mAx0qYDYC7QDGDQ=;
        h=Date:From:To:Subject:From;
        b=C5quJHmYh9KrXaUhcrJmMasKG72+WZ8WzC7Balco/RhUjkdrN6L/DYayqjrALdgvZ
         swH19ScgYsMm3rsPfVzqGESA6G6CQGcCNoNXjIfYQQLLkg2b4XL+3ExC/ZKAsIsFy0
         Sb5nDmPlvLnQnJWFn4LDo1kza+N/1K1lPYaPJ0r0=
Date:   Thu, 06 Aug 2020 16:18:45 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20200806231845.ytndB15Ht%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

