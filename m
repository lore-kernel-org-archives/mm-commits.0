Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0656CC43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE99F61477
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhD3F4r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3F4r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB5861459;
        Fri, 30 Apr 2021 05:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762160;
        bh=RRbSDkVkJUG2Ec57GCTCcaff5QDrWkOnx2HMFQtulYw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QDTGJX6xugcv6NvWJhZV55OmVJ2nB7JbwOiX0aKgXojiul/9HB8RR5EFFRzugyk7j
         u4l5J8kxYUqCbd3ID4aLiECL+4sFbb0XLoPj4dnFw9MaKwxZFsbp9xhFk+oCHHJUPc
         BSM/XDuOyTPsv3JOw2XoTYxUIY50wimEaQcNVPrU=
Date:   Thu, 29 Apr 2021 22:55:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daizhiyuan@phytium.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 055/178] mm/memremap.c: fix improper SPDX comment
 style
Message-ID: <20210430055559.lOhDfxgoN%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
