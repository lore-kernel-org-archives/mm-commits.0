Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DC8C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59CE661402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhEHWxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhEHWxx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 884656142D;
        Sat,  8 May 2021 22:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514371;
        bh=Jfz+Kf/xSXM0PmP7/zYcUZfI097Rp8cgDxe8Nswy9hE=;
        h=Date:From:To:Subject:From;
        b=LPhfbjdteOKYqGQN79jVW8DsyPXjxEbWNJMtFAv0KYGPFuWrBbZbGiFQkA2uxPvC2
         2QgeILRdVvcF3O7Ybqwk/hxjK+Pr7HSuFVaNR4js9LSn2rKgDdyf6KatFnoy25noOD
         ejH3bIuJaSlCe04nNZ2QQ1Eq8t0YLYKdb6diIG1g=
Date:   Sat, 08 May 2021 15:52:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangqing@vivo.com
Subject:  [merged]
 lib-fix-inconsistent-indenting-in-process_bit1.patch removed from -mm tree
Message-ID: <20210508225251.zbz1JQuxX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: fix inconsistent indenting in process_bit1()
has been removed from the -mm tree.  Its filename was
     lib-fix-inconsistent-indenting-in-process_bit1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


