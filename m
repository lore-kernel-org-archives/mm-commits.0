Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA387C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA6A62080D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595291340;
	bh=esBwqyxY1kd56zPKDl5VQx9khOvgvaqZ29/dNuwhdY8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=plZVexxX/G1Bxgg1MGE+3N1bDgWVhZtPbRP1Lzf+U6aMt7o9VUirn9c1Bus9h126U
	 nlFyvd4ChACHDh9Ze1K4e1SZua84aEF4oH8nGAXbKIWuUZDlnHYXyw70jZh5eIU1F+
	 a31ftVInegqsiNkR8WzbmQY9ib/S2344CU9eWpGo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGUA3A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgGUA3A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 20:29:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8944A207FC;
        Tue, 21 Jul 2020 00:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291339;
        bh=esBwqyxY1kd56zPKDl5VQx9khOvgvaqZ29/dNuwhdY8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HlrrWifAD7+RRYSbqNYW59CVjEZtEL31pyc3Usq0EgYGE9BR4IOtSVM9PEBCNfTlb
         7nOORXD5jYg3BB83RKrCFC8Vhe6WoxdMsYWrtY4o4H7u5IgKbsb1Yq2q8JLGt+6/5z
         go5KeKVotJd7XEWyrJKQ8rWv8D0HW8gHgM8unuxU=
Date:   Mon, 20 Jul 2020 17:28:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, natechancellor@gmail.com,
        rdunlap@infradead.org
Subject:  +
 clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch added
 to -mm tree
Message-ID: <20200721002859.OPKuN1sW_%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler-clang.h: drop duplicated word in a comment
has been added to the -mm tree.  Its filename is
     clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch

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
Subject: include/linux/compiler-clang.h: drop duplicated word in a comment

Drop the doubled word "the" in a comment.

Link: http://lkml.kernel.org/r/6a18c301-3505-742f-4dd7-0f38d0e537b9@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler-clang.h~clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment
+++ a/include/linux/compiler-clang.h
@@ -42,7 +42,7 @@
 #endif
 
 /*
- * Not all versions of clang implement the the type-generic versions
+ * Not all versions of clang implement the type-generic versions
  * of the builtin overflow checkers. Fortunately, clang implements
  * __has_builtin allowing us to avoid awkward version
  * checks. Unfortunately, we don't know which version of gcc clang
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
autofs-fix-doubled-word.patch

