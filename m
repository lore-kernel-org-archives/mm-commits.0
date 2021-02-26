Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7A9C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 20:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E173E64F0D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 20:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZUo3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 15:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhBZUo2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 15:44:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2304D64E21;
        Fri, 26 Feb 2021 20:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614372226;
        bh=8bYC1wF9XR0l493lW1NewHVUyWkidpF86YU1/Xor7E8=;
        h=Date:From:To:Subject:From;
        b=KGkzdniXmWH9AaHwfGLi1Z0Dh+Cg/Zb0EMFyydItALIqch6CqWaa4vi04+vrIpeh4
         e+JxRm3C8HdVeK5c1HrNpUWar1NVufEAfZChn3ZDghD54/Ql9Qrs2oTD96Gte3vV67
         MYnSHT7johvbvCTQZIRSdeAnpuwbOh6u69MAkEQQ=
Date:   Fri, 26 Feb 2021 12:43:45 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20210226204345.uqCLl7mgc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

 include/linux/pagemap.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pagemap.h~linux-next-rejects
+++ a/include/linux/pagemap.h
@@ -762,6 +762,8 @@ void delete_from_page_cache_batch(struct
 				  struct pagevec *pvec);
 loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
 		int whence);
+void readahead_expand(struct readahead_control *ractl,
+		      loff_t new_start, size_t new_len);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

