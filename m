Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A5BC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE322145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881584;
	bh=5HfSiS/vMZB8M/Ht2ooOQJwYyqJsJt0PBe/MD8IHL2A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DBddbJQVLKkkAFSQCINLHzO0J+KcaXqiF0mdV4qCowGzM4mJ3eOUxp7DwPEtOThPy
	 O7IMH7UqwXK45RZfp7KZfrmOcmH6C48Xu+NhDEfJre2+JiFku6gNBPnR7IQ2xr3cZN
	 Pf3PVI4yUn6x1Y4Qu6yBC2e7ckf1FzG+lOLcDmeI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408114AbgJPUxE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407010AbgJPUxE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B94205CB;
        Fri, 16 Oct 2020 20:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881583;
        bh=5HfSiS/vMZB8M/Ht2ooOQJwYyqJsJt0PBe/MD8IHL2A=;
        h=Date:From:To:Subject:From;
        b=bJNuuDDP5WumdPc1RUsKxwOvUhj/qubCKjc17vjalpk39AL1/ygdKGEzNi9u7nQ3K
         wyU26K2/uwV55w5GwPISPf2Wc1lqJDfHu7qUUsVCqdh+D0LkKZXNmtE3QFzy/Pa/Kj
         NCoBMGIODADzFlUfpJC8I+u+u6IRp2+vCjIgHegk=
Date:   Fri, 16 Oct 2020 13:53:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] lib-earlycpio-delete-duplicated-words.patch
 removed from -mm tree
Message-ID: <20201016205303.jOVbudB3F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: earlycpio: delete duplicated words
has been removed from the -mm tree.  Its filename was
     lib-earlycpio-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: earlycpio: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040455.25995-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/earlycpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/earlycpio.c~lib-earlycpio-delete-duplicated-words
+++ a/lib/earlycpio.c
@@ -42,7 +42,7 @@ enum cpio_fields {
 /**
  * cpio_data find_cpio_data - Search for files in an uncompressed cpio
  * @path:       The directory to search for, including a slash at the end
- * @data:       Pointer to the the cpio archive or a header inside
+ * @data:       Pointer to the cpio archive or a header inside
  * @len:        Remaining length of the cpio based on data pointer
  * @nextoff:    When a matching file is found, this is the offset from the
  *              beginning of the cpio to the beginning of the next file, not the
_

Patches currently in -mm which might be from rdunlap@infradead.org are


