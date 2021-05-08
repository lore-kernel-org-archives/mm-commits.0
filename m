Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871E9C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B0861415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWl5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E04F613EA;
        Sat,  8 May 2021 22:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513654;
        bh=vxImgkbikjaW7SMfXcut7SxJ9fy6iV42H/+qDAtzxUk=;
        h=Date:From:To:Subject:From;
        b=p3ExdDzp1BngO3BcNhYPx+QVpwqGuUBQDYndYA2ayKQWswlLwUxKNWq/65PlY6hze
         FcBDiaKG7M9zZNbNcYSsr/iVRVp4xjYMEsLlqbHRdwq1zbZj3WDWTVtXoD8D++vdn1
         fDTzFsFXfZ595se0O+RM+NybuxkGfXBzq4mN2cVk=
Date:   Sat, 08 May 2021 15:40:54 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-memremap-fixes-improper-spdx-comment-style.patch removed from -mm tree
Message-ID: <20210508224054.EITHDZdgm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap.c: fix improper SPDX comment style
has been removed from the -mm tree.  Its filename was
     mm-memremap-fixes-improper-spdx-comment-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


