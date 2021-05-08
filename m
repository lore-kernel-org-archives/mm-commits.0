Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D740C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 427BA61415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhEHWqX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWqX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A649613C5;
        Sat,  8 May 2021 22:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513921;
        bh=I4sv7vS6ef+XouT7aTbsIEaCh6W6LJ25pkDG/W0AtJQ=;
        h=Date:From:To:Subject:From;
        b=wGRZ4EAmN2AeLMJfx8m8FnwFXHcZtvapxLcIDxFhLNFjilwSUH22VeNE2Nb3lo3Eu
         Uqz0xb6DX81CsxDjpr4S1aA/TnUy/j7fmN1OE8S1YeA1v76Umcx63kTemK+7hprgYO
         RSZDzO7gHC1r9zsFoPc0d+YqUKCVxPFXiaNbTvto=
Date:   Sat, 08 May 2021 15:45:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhouchuangao@vivo.com
Subject:  [merged]
 mm-page_alloc-duplicate-include-linux-vmalloch.patch removed from -mm tree
Message-ID: <20210508224521.jsC3YuSBv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: duplicate include linux/vmalloc.h
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-duplicate-include-linux-vmalloch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhouchuangao <zhouchuangao@vivo.com>
Subject: mm/page_alloc: duplicate include linux/vmalloc.h

linux/vmalloc.h is repeatedly in the file page_alloc.c

Link: https://lkml.kernel.org/r/1616468751-80656-1-git-send-email-zhouchuangao@vivo.com
Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-duplicate-include-linux-vmalloch
+++ a/mm/page_alloc.c
@@ -72,8 +72,6 @@
 #include <linux/padata.h>
 #include <linux/khugepaged.h>
 #include <linux/buffer_head.h>
-#include <linux/vmalloc.h>
-
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
_

Patches currently in -mm which might be from zhouchuangao@vivo.com are


