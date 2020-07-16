Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC88C433FB
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA9542070E
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594941021;
	bh=cJtg35BV9aCJosxvi07LloY61owQf1oFLP/HaPmJXEk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=m6XOARQ6GelfmfKi83f/I7HdzGfbfHhWnuDtqbYpU5Rx7cpMOXvF8J1N5Gb8i4N9m
	 YFeldwRwdhf0e53fw46r38Q36i+Mii+RyCbdxca7YRU0GkToPTLzdywJWwJthc1SZ+
	 YqX1iHwZ54pksZ2nVg2nfZNasbF2Qk3Gw1H6L754=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgGPXKV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgGPXKR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 19:10:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8926A2098B;
        Thu, 16 Jul 2020 22:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594939931;
        bh=cJtg35BV9aCJosxvi07LloY61owQf1oFLP/HaPmJXEk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qn4Bt1kBxjEtTAL8l7VAeU4DzFcLqLvzzj2SBK7oF5ZSSVkKx0sbrDLTMch4bckax
         EM+Bnc1ioQntsSDCFhE5uNsb8RQu0Y7KL2oyIgNG+4VWYyjOL8tLHGn/qzvOALkMM0
         ZgbcKXAfdgsqk+EKbqU20mt3iPply8Pd6qNzv3jk=
Date:   Thu, 16 Jul 2020 15:52:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, sjpark@amazon.de
Subject:  + mm-drop-duplicated-words-in-linux-mmh.patch added to
 -mm tree
Message-ID: <20200716225211.fgUPmgBS1%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop duplicated words in <linux/mm.h>
has been added to the -mm tree.  Its filename is
     mm-drop-duplicated-words-in-linux-mmh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-duplicated-words-in-linux-mmh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-duplicated-words-in-linux-mmh.patch

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
Subject: mm: drop duplicated words in <linux/mm.h>

Drop the doubled words "to" and "the".

Link: http://lkml.kernel.org/r/d9fae8d6-0d60-4d52-9385-3199ee98de49@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-drop-duplicated-words-in-linux-mmh
+++ a/include/linux/mm.h
@@ -482,7 +482,7 @@ static inline bool fault_flag_allow_retr
 	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
 
 /*
- * vm_fault is filled by the the pagefault handler and passed to the vma's
+ * vm_fault is filled by the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
  *
@@ -2601,7 +2601,7 @@ extern unsigned long stack_guard_gap;
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
 
-/* CONFIG_STACK_GROWSUP still needs to to grow downwards at some places */
+/* CONFIG_STACK_GROWSUP still needs to grow downwards at some places */
 extern int expand_downwards(struct vm_area_struct *vma,
 		unsigned long address);
 #if VM_GROWSUP
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch

