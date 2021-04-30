Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3477AC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0606961452
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3FXq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FXq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F214961423;
        Fri, 30 Apr 2021 05:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760179;
        bh=xulSAfXKjPdAFmLVQ/TUBdwEHCYtDw1VXVaD3Ml9sFY=;
        h=Date:From:To:Subject:From;
        b=nfqV+ZXNO65bhIkcuTd+3blda88gRjvPEC5VyUJbiMmdSldoK41ioL0TJOWUKYTuv
         4OpYMFs3TYn3QgRIEJzALLvpivn87jCNlga6DBOsFmOEXpywH1oQUhifU9e8dioaAn
         jTEyJnxdvpAoQURT5VDMmXc6OgMKGcaUV5aP7yns=
Date:   Thu, 29 Apr 2021 22:22:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org
Subject:  [folded-merged] mm-memcontrol-switch-to-rstat-fix.patch
 removed from -mm tree
Message-ID: <20210430052258.E1qVVONO7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-switch-to-rstat-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-switch-to-rstat-fix.patch

This patch was dropped because it was folded into mm-memcontrol-switch-to-rstat.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-switch-to-rstat-fix

merge fix

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-switch-to-rstat-fix
+++ a/include/linux/memcontrol.h
@@ -1373,7 +1373,7 @@ void count_memcg_event_mm(struct mm_stru
 {
 }
 
-static inline void split_page_memcg(struct page *head)
+static inline void split_page_memcg(struct page *head, unsigned int nr)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-switch-to-rstat.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

