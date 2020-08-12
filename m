Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC32C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 594FC2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266196;
	bh=3esmNPRNDvSooQkPVEQbYeDKSRqNkSW+Vuzez2j6wqo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VUWiCKIwjA0FqDW+e3N2eP9VBnZptIAt9PgMqvVLjZhonzlwIAeCKSyhFhdFxk9r4
	 OvoDfHS1KOCRgChsR+GPRQBPk+lgCRojtspicpvGZSJ/dT5YLd3xRKGIIZBRvdX36h
	 38fCoU9tQC8FsMy92kD7zGRGagsucMbrKvE1YYKw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHLVDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62D5B20774;
        Wed, 12 Aug 2020 21:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266195;
        bh=3esmNPRNDvSooQkPVEQbYeDKSRqNkSW+Vuzez2j6wqo=;
        h=Date:From:To:Subject:From;
        b=O4+wGlajP+tSgnErNVnfFcvy6ZBxB8Z4xjmBIhVyN9v6u1quPrh62ugbBz6F9jBt6
         Gq++47LTDjOasJJtdRgNa5YEekdwU9pk7QOFShut/gQfL50Nt81/3G3BDIrQliWef+
         uv4syVsDz9EYWShTFdnZBa6/S/ikrOCuAJMtR8/U=
Date:   Wed, 12 Aug 2020 14:03:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-zsmallocc-fix-duplicated-words.patch removed
 from -mm tree
Message-ID: <20200812210315.EHfydfOkU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: fix duplicated words
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-fix-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/zsmalloc.c: fix duplicated words

Change "as as" to "as a".

Link: http://lkml.kernel.org/r/20200801173822.14973-16-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-fix-duplicated-words
+++ a/mm/zsmalloc.c
@@ -79,7 +79,7 @@
 
 /*
  * Object location (<PFN>, <obj_idx>) is encoded as
- * as single (unsigned long) handle value.
+ * a single (unsigned long) handle value.
  *
  * Note that object index <obj_idx> starts from 0.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are


