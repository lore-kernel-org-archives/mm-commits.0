Return-Path: <SRS0=txOa=DW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8BFC433E7
	for <mm-commits@archiver.kernel.org>; Thu, 15 Oct 2020 23:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 912EF2080A
	for <mm-commits@archiver.kernel.org>; Thu, 15 Oct 2020 23:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602803247;
	bh=FU7fU0BT7hFSHTUQVSCdvQi7yY4pm3aJBLuy9e5Fb9s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=U6XJwcTAS1yCp6cycyFI8F+CAyYS1a4J8rl3Grrw9QpS0aWY24af6Q8utU6quWHKV
	 96H/Ysv8iMqJ9JZO8rU8QpRNMmB6x+WidoNt/VW4M/tnuzB0SHMfijI84mqutTN6nz
	 rw8NeD3R03g2xj2dsL9zoA24qKuChJQBhEUkhbgY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732472AbgJOXH1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 19:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732223AbgJOXH0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 19:07:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A9D207C4;
        Thu, 15 Oct 2020 23:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602803245;
        bh=FU7fU0BT7hFSHTUQVSCdvQi7yY4pm3aJBLuy9e5Fb9s=;
        h=Date:From:To:Subject:From;
        b=0jxoLe16/maguWLOqOdaoTMV+cqUfh7pEUtm8YxTrd/iZXGsPFFP04NPf0bqqKAqD
         Q+i4tWKMJf5YJ5g8RB260A9IuUe2ti0rLB7SM5lVatH09TYGJaJvSZ4APKwu24iGO1
         dorACOxXnZ3jcaq3jD7v73yXcJhZ2YNa6tpij1lo=
Date:   Thu, 15 Oct 2020 16:07:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [alternative-merged]
 lib-devres-delete-duplicated-words.patch removed from -mm tree
Message-ID: <20201015230724.03Jz6N9la%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: devres: delete duplicated words
has been removed from the -mm tree.  Its filename was
     lib-devres-delete-duplicated-words.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: devres: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040443.25900-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/devres.c~lib-devres-delete-duplicated-words
+++ a/lib/devres.c
@@ -217,7 +217,7 @@ void __iomem *devm_ioremap_resource_wc(s
  * Please Note: This is not a one-to-one replacement for of_iomap() because the
  * of_iomap() function does not track whether the region is already mapped.  If
  * two drivers try to map the same memory, the of_iomap() function will succeed
- * but the the devm_of_iomap() function will return -EBUSY.
+ * but the devm_of_iomap() function will return -EBUSY.
  *
  */
 void __iomem *devm_of_iomap(struct device *dev, struct device_node *node, int index,
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-configfs-delete-repeated-words-in-comments.patch
kernel-fix-repeated-words-in-comments.patch
kernel-acctc-fix-some-kernel-doc-nits.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch
lib-mpi-fix-spello-of-functions.patch

