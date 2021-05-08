Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03701C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE0BD61448
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEHWxw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhEHWxv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C86361424;
        Sat,  8 May 2021 22:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514369;
        bh=lR4QMXNLnrQ7DsyH+5Ui8OgEwP8GZyfm8tpH/HEsxT4=;
        h=Date:From:To:Subject:From;
        b=d00BNoJY6NK+MBNKgtRuII8jrqzAjI31emGhTzT9ZoS2m3jWWTbZKmn+gOnNSCLba
         ecJlldUnY9k4DnzvxbOoN+BQR5809BWr0Cf7tbCZflY0IEpiNzEH/F/emQC64yca2O
         qX+gNenl4Kt19reyys1UeoVutOJAS7lR5PZxxqCo=
Date:   Sat, 08 May 2021 15:52:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  [merged] lib-fix-a-typo-in-the-file-bchc.patch removed
 from -mm tree
Message-ID: <20210508225249.lwbIB9sc8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bch.c: fix a typo in the file bch.c
has been removed from the -mm tree.  Its filename was
     lib-fix-a-typo-in-the-file-bchc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: lib/bch.c: fix a typo in the file bch.c

s/buid/build/

Link: https://lkml.kernel.org/r/20210301123129.18754-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bch.c~lib-fix-a-typo-in-the-file-bchc
+++ a/lib/bch.c
@@ -584,7 +584,7 @@ static int find_affine4_roots(struct bch
 	k = a_log(bch, a);
 	rows[0] = c;
 
-	/* buid linear system to solve X^4+aX^2+bX+c = 0 */
+	/* build linear system to solve X^4+aX^2+bX+c = 0 */
 	for (i = 0; i < m; i++) {
 		rows[i+1] = bch->a_pow_tab[4*i]^
 			(a ? bch->a_pow_tab[mod_s(bch, k)] : 0)^
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


