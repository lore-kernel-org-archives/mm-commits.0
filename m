Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C783C43332
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2893D64EFE
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241283AbhCDA7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354819AbhCDALM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:11:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A361064EE6;
        Thu,  4 Mar 2021 00:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816629;
        bh=csVE8mAC3g7P5J/h/WYAV+1m2fEOWM483OuhOoRtskM=;
        h=Date:From:To:Subject:From;
        b=Ur7eyslRNPgqVIdWd8UTlT0iN9AoBI4otHxmYkoOHtUqjEtpi7U6A7NTJckl2UDO6
         PeTjgr6larl2MQJ/tWOYYDP8uuhKjsTO5yuGpEysuphU9WFgFAhxlY7g9zhVUZNS0O
         vbNvB4UHgoasQkFZHGX+xrWTcIZcpPNCE9PvZtR8=
Date:   Wed, 03 Mar 2021 16:10:29 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-memremap-fixes-improper-spdx-comment-style.patch
 added to -mm tree
Message-ID: <20210304001029.G5bmzqLHN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap.c: fix improper SPDX comment style
has been added to the -mm tree.  Its filename is
     mm-memremap-fixes-improper-spdx-comment-style.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memremap-fixes-improper-spdx-comment-style.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memremap-fixes-improper-spdx-comment-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/memremap.c: fix improper SPDX comment style

Replace /* */ comment with //, fix SPDX comment style.

see: Documentation/process/license-rules.rst

Link: https://lkml.kernel.org/r/1614223348-15516-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memremap-fixes-improper-spdx-comment-style
+++ a/mm/memremap.c
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2015 Intel Corporation. All rights reserved. */
 #include <linux/device.h>
 #include <linux/io.h>
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch

