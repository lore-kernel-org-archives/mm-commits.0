Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B48C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD16216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881572;
	bh=88r697vFO3I6tgDBz2Ycp0YMbSjzux9zeIzb7TsV0b4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=m6orPbInEsfpOS64Q/pk2yNPpYDS/ne+2A58Oq3KsXIGTsp7B60I/aO7Gf6FJwvvr
	 8ytraFk7BYpNpsX0k7qwzoISJh3eR1nrQVe64Z7jWIRXSAWr9LF1dHOxeFj7m6JyEe
	 2uImRsLQqf+xl34ljUDxkDZGqZ2WIRQllXQaplDc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409056AbgJPUww (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E71A2145D;
        Fri, 16 Oct 2020 20:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881571;
        bh=88r697vFO3I6tgDBz2Ycp0YMbSjzux9zeIzb7TsV0b4=;
        h=Date:From:To:Subject:From;
        b=Fmket2xcQ9pfA4ze1bSJvY3deWuzYqUPKPN1ZDyUvCP3gvNyRWG1OJgNj05RjtLqF
         X5N7TYWmSVJOwlY8Zf7FlKwa7R2JAGNtAH+vYq5hJnaTVzFbfayhJ6ggshKPfqEBv4
         7KyQVQN+o9bghkskvdheO78pDeSIlKXRcQbfndMI=
Date:   Fri, 16 Oct 2020 13:52:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] lib-bitmap-delete-duplicated-words.patch removed
 from -mm tree
Message-ID: <20201016205251.ePjrH0Jd2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: delete duplicated words
has been removed from the -mm tree.  Its filename was
     lib-bitmap-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: bitmap: delete duplicated words

Drop the repeated word "an".

Link: https://lkml.kernel.org/r/20200823040424.25760-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bitmap.c~lib-bitmap-delete-duplicated-words
+++ a/lib/bitmap.c
@@ -23,7 +23,7 @@
 /**
  * DOC: bitmap introduction
  *
- * bitmaps provide an array of bits, implemented using an an
+ * bitmaps provide an array of bits, implemented using an
  * array of unsigned longs.  The number of valid bits in a
  * given bitmap does _not_ need to be an exact multiple of
  * BITS_PER_LONG.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


