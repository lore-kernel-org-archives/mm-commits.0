Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67371C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D55D61078
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhEEBBH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231600AbhEEBBG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9998613CB;
        Wed,  5 May 2021 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176410;
        bh=BKvAaeLXDcCQ5v+6y3W0CxtKoKr+NrRbgmEPhxg1FAM=;
        h=Date:From:To:Subject:From;
        b=f6IE+VSykIP1xRjmyHOwWLCUWvBTCDPmmQM8RCYCPiJFSqUITphPKSeeMeGPQ187p
         sH46E6A2JR4XpgwRI97pKG8rhdTgVTiVWgePOPkVzjZTEqbeVF/sCep/wq3onnxQ2K
         SpZhNPNbutyawVrPldqbG8UGf8baVUvAKB0KPEVs=
Date:   Tue, 04 May 2021 18:00:10 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-oom_kill-minor-coding-style-tweaks.patch removed from -mm tree
Message-ID: <20210505010010.a_b6SqZOU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-minor-coding-style-tweaks.patch

This patch was dropped because it was folded into mm-mempool-minor-coding-style-tweaks.patch

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/oom_kill: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1614228360-21168-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom_kill-minor-coding-style-tweaks
+++ a/mm/oom_kill.c
@@ -993,7 +993,7 @@ static void oom_kill_process(struct oom_
 	if (oom_group) {
 		mem_cgroup_print_oom_group(oom_group);
 		mem_cgroup_scan_tasks(oom_group, oom_kill_memcg_member,
-				      (void*)message);
+				      (void *)message);
 		mem_cgroup_put(oom_group);
 	}
 }
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-mempool-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

