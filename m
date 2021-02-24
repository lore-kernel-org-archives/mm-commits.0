Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D81C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080D064EBA
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhBXUBb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhBXUA7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:00:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 087EF64E2B;
        Wed, 24 Feb 2021 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196819;
        bh=ReO0lxwlyE3MFnpfHhj39/n4lOBBeambyL5c9OIfQKs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2rPDiNNS6upRZK69P78UDFiLeAfjlQsDpyUFlgazsFAyrTQ8pqfEomSh9IkOJm2fm
         6bpELYUPJrQwogszTjeMvrhlgrXSwZQLuesbi5poSRDUcCgTeqAW63MERq/ssbwu2b
         kptMdv0V5LBbRICPlxt3s0tDLJScVdrHoAsvp6j8=
Date:   Wed, 24 Feb 2021 12:00:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zuoqilin@yulong.com
Subject:  [patch 003/173] scripts/spelling.txt: check for "exeeds"
Message-ID: <20210224200018.kFGvkPr92%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>
Subject: scripts/spelling.txt: check for "exeeds"

Increase exeeds spelling error check.

Link: https://lkml.kernel.org/r/20210127060049.915-1-zuoqilin1@163.com
Signed-off-by: zuoqilin <zuoqilin@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-increase-error-prone-spell-checking-2
+++ a/scripts/spelling.txt
@@ -566,6 +566,7 @@ estbalishment||establishment
 etsablishment||establishment
 etsbalishment||establishment
 evalution||evaluation
+exeeds||exceeds
 excecutable||executable
 exceded||exceeded
 exceds||exceeds
_
