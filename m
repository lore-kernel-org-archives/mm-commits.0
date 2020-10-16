Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E100C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0FCC218AC
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881576;
	bh=AmESCmCG3p1d9lnvFKpurnm5Gb25biaWtfHChmtS0ss=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DG/ZfvgQIETCGk5P1lB3aO2Unoukoz1G7obRSmdxZFKw/1CR37r5ZhGm0ntheY6Gj
	 P+MmHCXGKR9y5UXlcl794uqxUPNIxkLoAxSxRBDiVU/6l5OIqzna74LbnZljtcribn
	 eTQ4A/KTJf9BGYXhrhfkn8E6OVB1rZXdp1/TLZi8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392725AbgJPUwz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUwz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A719F2076C;
        Fri, 16 Oct 2020 20:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881574;
        bh=AmESCmCG3p1d9lnvFKpurnm5Gb25biaWtfHChmtS0ss=;
        h=Date:From:To:Subject:From;
        b=baq72gh9G9VuGqG4QUpmdH0Urx1ojdXTGCTzDEDqy4rCEp+oBHJ6D5wYZBkM1XjTj
         R52dXwq12ul8WhXzmJvs7ufBcukYgB6fGgDLPKr5wRVGjl1zm02vx6BJjDCZlIF+Ay
         rFk/uhoCjwZtC22r6GfetHzYyaxzIEvTZ8GgMU5I=
Date:   Fri, 16 Oct 2020 13:52:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] lib-libcrc32c-delete-duplicated-words.patch
 removed from -mm tree
Message-ID: <20201016205254.Uqj-USzc3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: libcrc32c: delete duplicated words
has been removed from the -mm tree.  Its filename was
     lib-libcrc32c-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


