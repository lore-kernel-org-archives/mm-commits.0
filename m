Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957FEC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63C22613CD
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhEEBBA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhEEBA7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C7F0613BA;
        Wed,  5 May 2021 01:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176402;
        bh=jvDWk8qGBiNPjH/oU+CUfzFLAiGyqN85NlpQMXpd+lg=;
        h=Date:From:To:Subject:From;
        b=dkJSUFOStfxluV8BAwnXD6jRnEp50OTKhQQ4SrItDovuZMzX6lrWIaMkwwYf2GuaB
         LCKjWIXee9HWL/FLU6oolwXNLy2AZttGbdDjN3QlCPnkb8/xiOfmanZ8l1OKsAM942
         zJVyXANVIvWM47KJL/OttDWFUdFvue9Zcw7EpKcU=
Date:   Tue, 04 May 2021 18:00:01 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-swapfile-minor-coding-style-tweaks.patch removed from -mm tree
Message-ID: <20210505010001.09PBB5N5d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-swapfile-minor-coding-style-tweaks.patch

This patch was dropped because it was folded into mm-mempool-minor-coding-style-tweaks.patch

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/swapfile: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1614223624-16055-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-minor-coding-style-tweaks
+++ a/mm/swapfile.c
@@ -2780,7 +2780,7 @@ static int swap_show(struct seq_file *sw
 	unsigned int bytes, inuse;
 
 	if (si == SEQ_START_TOKEN) {
-		seq_puts(swap,"Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPriority\n");
+		seq_puts(swap, "Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPriority\n");
 		return 0;
 	}
 
@@ -3284,7 +3284,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 					 sizeof(long),
 					 GFP_KERNEL);
 
-	if (p->bdev &&(swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
+	if (p->bdev && (swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
 		/*
 		 * When discard is enabled for swap with no particular
 		 * policy flagged, we set all swap discard flags here in
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-mempool-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

