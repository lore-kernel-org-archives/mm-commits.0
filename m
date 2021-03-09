Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B37C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 02:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA2264F86
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 02:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhCICCb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 21:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhCICCJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 21:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B31C064F86;
        Tue,  9 Mar 2021 02:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615255328;
        bh=mDChaULj3A07Yi72DnDQMJtEiekCfqb64c7AclQBY3E=;
        h=Date:From:To:Subject:From;
        b=0hozpBPMa1eVhiWLCY0tcOUs045TTCRBID5nkZo0dXxlRl0KLh8Wpf7G3gGsuJbhV
         2QBI6M0YpcX/aF6t9gtaOKTOq/FFCUZ0xFwGKy/MXr1y7KIu7FvotOKBFLlwdRJTr5
         WtyRH1Xm15kXCWOoOAN7jm6Zu0WhnM3l+sz/NEd4=
Date:   Mon, 08 Mar 2021 18:02:08 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org
Subject:  + mm-memcontrol-switch-to-rstat-fix.patch added to -mm
 tree
Message-ID: <20210309020208.Oz9AQH9ee%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-switch-to-rstat-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-switch-to-rstat-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-switch-to-rstat-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-switch-to-rstat-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1386,7 +1386,7 @@ void count_memcg_event_mm(struct mm_stru
 {
 }
 
-static inline void split_page_memcg(struct page *head)
+static inline void split_page_memcg(struct page *head, unsigned int nr)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

