Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB565C433E4
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D5482064B
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594941027;
	bh=bDuHPxx+7wOoiMndbuLLABRX6tPk3lsoOAH0gQDFp9M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lMy+kCZ2HHgVlWqQyN17+3r7/Q/SYOpEYifmO7Tpvzq0Ir8+nYu4GdP6iPoz25jgO
	 piRxy9srnZkKu3glS2qvBAD8RcFItZ91370Hk0VrKxWg5x1PxE8RKXQuuquGj+qBQH
	 LAM3hIDruBKMOMExp18Qv5FK09x6MZVeGhxKor4U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgGPXKW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbgGPXKV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 19:10:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A631620870;
        Thu, 16 Jul 2020 22:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594939861;
        bh=bDuHPxx+7wOoiMndbuLLABRX6tPk3lsoOAH0gQDFp9M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jYeydxVOkoZpGRskVpRw1fyx0/Qm4jtNbJtuRzSTDq/++R1bJWvUcC8It/q7HudX+
         zwbk0DuPxqNzY+v55BYk6Mx0zKz1GrEhFW3o5kyC1OAfcCBcxiB/JRv7vyWyBEKp4/
         YmVDw56iHmrvOEiy9GU3YkvbPqD+V/YPJdMFoe2M=
Date:   Thu, 16 Jul 2020 15:51:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, sjpark@amazon.de
Subject:  + linux-sched-mmh-drop-duplicated-words-in-comments.patch
 added to -mm tree
Message-ID: <20200716225101.1Nsvkt3PP%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/sched/mm.h: drop duplicated words in comments
has been added to the -mm tree.  Its filename is
     linux-sched-mmh-drop-duplicated-words-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-sched-mmh-drop-duplicated-words-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-sched-mmh-drop-duplicated-words-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: linux/sched/mm.h: drop duplicated words in comments

Drop doubled words "to" and "that".

Link: http://lkml.kernel.org/r/927ea8d8-3f6c-9b65-4c2b-63ab4bd59ef1@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/sched/mm.h~linux-sched-mmh-drop-duplicated-words-in-comments
+++ a/include/linux/sched/mm.h
@@ -23,7 +23,7 @@ extern struct mm_struct *mm_alloc(void);
  * will still exist later on and mmget_not_zero() has to be used before
  * accessing it.
  *
- * This is a preferred way to to pin @mm for a longer/unbounded amount
+ * This is a preferred way to pin @mm for a longer/unbounded amount
  * of time.
  *
  * Use mmdrop() to release the reference acquired by mmgrab().
@@ -236,7 +236,7 @@ static inline unsigned int memalloc_noio
  * @flags: Flags to restore.
  *
  * Ends the implicit GFP_NOIO scope started by memalloc_noio_save function.
- * Always make sure that that the given flags is the return value from the
+ * Always make sure that the given flags is the return value from the
  * pairing memalloc_noio_save call.
  */
 static inline void memalloc_noio_restore(unsigned int flags)
@@ -267,7 +267,7 @@ static inline unsigned int memalloc_nofs
  * @flags: Flags to restore.
  *
  * Ends the implicit GFP_NOFS scope started by memalloc_nofs_save function.
- * Always make sure that that the given flags is the return value from the
+ * Always make sure that the given flags is the return value from the
  * pairing memalloc_nofs_save call.
  */
 static inline void memalloc_nofs_restore(unsigned int flags)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-sched-mmh-drop-duplicated-words-in-comments.patch

