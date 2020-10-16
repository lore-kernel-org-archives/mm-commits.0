Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCCFC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF622087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817851;
	bh=XfL4+YLfBQeQRKGH2IwJpIRgEcC2eanycssYvIyZNgU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qfe/dEk7w4WgUANDKDaf+s2eV0ZikTKMVAIXK1a7A6UDDehttkkyirJbcsSg3IMIT
	 29LGu5TmOG6DqLEmXa22K6FHRTIQH7xzUpg9NBJ5lmC60fb1Eg8hLFbo/SYQycEEV/
	 axm/LU/DrVaYeA9UfkjJKxWdwXUbsD2rNXd21UCU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387963AbgJPDKv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDKv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F329A20878;
        Fri, 16 Oct 2020 03:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817849;
        bh=XfL4+YLfBQeQRKGH2IwJpIRgEcC2eanycssYvIyZNgU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HufmhkfsgFiqsAHa4RWnRiWrHT5ghS1PPWtyxgzL1OmNpcsDUFc94Y49yBsv1ATWE
         R5Vxdr/JxQ9NtgufOuDf9Dkc7DyGUjhD5DaTOoyZ8GOw/TnL4g8nO8WbGv0liQWQg+
         n4XEwN7mfYWr2JCOJCTaQuuFVQasPuqwetaPEWq4=
Date:   Thu, 15 Oct 2020 20:10:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 104/156] lib: libcrc32c: delete duplicated words
Message-ID: <20201016031048.QAIdMQKQv%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: libcrc32c: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040430.25807-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/libcrc32c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/libcrc32c.c~lib-libcrc32c-delete-duplicated-words
+++ a/lib/libcrc32c.c
@@ -12,7 +12,7 @@
  * pages =        {},
  * month =        {June},
  *}
- * Used by the iSCSI driver, possibly others, and derived from the
+ * Used by the iSCSI driver, possibly others, and derived from
  * the iscsi-crc.c module of the linux-iscsi driver at
  * http://linux-iscsi.sourceforge.net.
  *
_
