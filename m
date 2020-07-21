Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEF9C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B225521702
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595291279;
	bh=RAmEIZ8ZnE7kUFRrkN1kcHssi4cDzP0Y9943YQVKxtg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OwvLdrCaFgFMVGKZz8EVI/qlr1hhpVduOHVt9/ISzf4YyZ5/t78DJUcyF3FLjp2u6
	 P5srQVReTw9j+KCZyM+XFfUpZYyXVlOyOnthD4M7didY0346wjHejEp/h5WEvAa1sK
	 NMmGFFH4Zv1UA7pm724ym/Cbi5DD+roiCFKgbPQ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGUA17 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgGUA17 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 20:27:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8556B207FC;
        Tue, 21 Jul 2020 00:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291278;
        bh=RAmEIZ8ZnE7kUFRrkN1kcHssi4cDzP0Y9943YQVKxtg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mfGFswikPIUVzErechhBqOEcMycyUw+UmuXUM9u+TIA+dAoia/C4RIGZ4bK7YjcuS
         +ZC/HJ6G5izTIav/glcn8EPynwoi3aMk6yhE1jmX78YYyEIHdJ45T0d7KdLmjT0dzo
         PdR/nZyMrDH6eeVh/PIcuY/BbPnz/ck0GmP/SvVo=
Date:   Mon, 20 Jul 2020 17:27:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch added to -mm
 tree
Message-ID: <20200721002758.XKGCQqM0B%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/highmem.h: fix duplicated words in a comment
has been added to the -mm tree.  Its filename is
     highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch

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
Subject: include/linux/highmem.h: fix duplicated words in a comment

Change the doubled word "is" in a comment to "it is".

Link: http://lkml.kernel.org/r/ad605959-0083-4794-8d31-6b073300dd6f@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~highmem-linux-highmemh-fix-duplicated-words-in-a-comment
+++ a/include/linux/highmem.h
@@ -73,7 +73,7 @@ static inline void kunmap(struct page *p
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
- * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * However when holding an atomic kmap it is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  *
  * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
autofs-fix-doubled-word.patch

