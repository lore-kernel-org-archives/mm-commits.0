Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A4FC4332D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0843264EE2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBZBSq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhBZBSh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:18:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 249D564EE2;
        Fri, 26 Feb 2021 01:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302277;
        bh=nnM15vyTjuZ9kcFFuXedpY6eYM0ZkmiHxsNpuhRHedw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QplGDlDLeTUYJ7l05mrnfxo29Uq9o+YyArXlFRWNT7sd7FvgD4rQozLi3e1dVfziq
         B6LDyeFA0SQWjw7z4PtkLjHpgbjSVk+1uEgNVEylyKPG8JMP3sJYZuLiprrlMXFbN1
         LRNuZVdtzDqwS4U9Uaw7whlGgKzeJGN/3cOPrzwI=
Date:   Thu, 25 Feb 2021 17:17:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 041/118] mm/rmap: remove unneeded semicolon in
 page_not_mapped()
Message-ID: <20210226011756.5hKyPUbmv%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: remove unneeded semicolon in page_not_mapped()

Remove extra semicolon without any functional change intended.

Link: https://lkml.kernel.org/r/20210127093425.39640-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-remove-unneeded-semicolon-in-page_not_mapped
+++ a/mm/rmap.c
@@ -1784,7 +1784,7 @@ bool try_to_unmap(struct page *page, enu
 static int page_not_mapped(struct page *page)
 {
 	return !page_mapped(page);
-};
+}
 
 /**
  * try_to_munlock - try to munlock a page
_
