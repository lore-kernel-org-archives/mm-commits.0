Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9409DC4332B
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 565A964E87
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381735AbhCCNaj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232552AbhCCAgo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 19:36:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B500164FB4;
        Wed,  3 Mar 2021 00:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614731747;
        bh=vtaZNe5rh2ohqvH4MnwlhQTPLffyofmg3+qxmevVAuw=;
        h=Date:From:To:Subject:From;
        b=Ep8jqn0jZHvvM0MOzoYWyBJ1/ZQ2G+EAQTyu5rPKkCQPlfM5ClPTGe1xpiku9ujIC
         ftS9x3JqEpn9U0Al3kpZhpKCW8HTSBX5PuH7Ngi5jhLGC3gnkiTjw0j73lFI/RLhYs
         /NsIhc4N0mbNOiV7bZr27TuECGYc18U4PVY1lCXM=
Date:   Tue, 02 Mar 2021 16:35:47 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangqing@vivo.com
Subject:  + lib-fix-inconsistent-indenting-in-process_bit1.patch
 added to -mm tree
Message-ID: <20210303003547.vT7KCmGCg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: fix inconsistent indenting in process_bit1()
has been added to the -mm tree.  Its filename is
     lib-fix-inconsistent-indenting-in-process_bit1.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-fix-inconsistent-indenting-in-process_bit1.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-fix-inconsistent-indenting-in-process_bit1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: lib: fix inconsistent indenting in process_bit1()

Smatch gives the warning:
	lib/decompress_unlzma.c:395 process_bit1() warn: inconsistent indenting

Link: https://lkml.kernel.org/r/1614567775-4478-1-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_unlzma.c~lib-fix-inconsistent-indenting-in-process_bit1
+++ a/lib/decompress_unlzma.c
@@ -391,7 +391,7 @@ static inline int INIT process_bit0(stru
 static inline int INIT process_bit1(struct writer *wr, struct rc *rc,
 					    struct cstate *cst, uint16_t *p,
 					    int pos_state, uint16_t *prob) {
-  int offset;
+	int offset;
 	uint16_t *prob_len;
 	int num_bits;
 	int len;
_

Patches currently in -mm which might be from wangqing@vivo.com are

mm-delete-bool-migrated.patch
lib-fix-inconsistent-indenting-in-process_bit1.patch

