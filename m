Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62331C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C0021D7A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632893;
	bh=nB+w47ry+JNcMkmMgpptd4G2V/IoRbyV2aBcAh6fg5M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GqUaJxCe2ttpZskg9b6tGd3EKig2PP7cd3k2M6lTADT46t2cRehiRc3+l1qKVsb7k
	 KuCIq+9Ia2Qj4k0Wq6aoeoMdDmfJfLP8lcXMG1ngBzJQ2f8KFVt5cFVIyLQH3P2xgX
	 wbf3v5MykmK9cVz2HsXZdCeSAlo81KEd8lM6uYlo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389144AbgJMXsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXsM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1886C21D7F;
        Tue, 13 Oct 2020 23:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632892;
        bh=nB+w47ry+JNcMkmMgpptd4G2V/IoRbyV2aBcAh6fg5M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d9LG068HbZ/+nyikMptfNzP4ThWX4Nq/9SJAqKIm8dm3BI8n4CRP37dRv5cWkGQxO
         /BEIqGkxmdWjgzuyw3rTbmsPG0QsYhrAxmwlF62ejDA7HXrJuVfDN7Dw2zsJ2jCEzD
         Bz18RwZoukOPOOeAosFGAc3tfajB3tTafV9CG+fs=
Date:   Tue, 13 Oct 2020 16:48:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apw@canonical.com,
        colin.king@canonical.com, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoki.hayama@lineo.co.jp,
        torvalds@linux-foundation.org
Subject:  [patch 012/181] scripts/spelling.txt: add "arbitrary"
 typo
Message-ID: <20201013234811.jnZIn3qzC%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoki Hayama <naoki.hayama@lineo.co.jp>
Subject: scripts/spelling.txt: add "arbitrary" typo

Add "abitrary||arbitrary".

Link: https://lkml.kernel.org/r/6bf6520d-787d-5749-09b5-ff92185f501f@lineo.co.jp
Signed-off-by: Naoki Hayama <naoki.hayama@lineo.co.jp>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-arbitrary-typo
+++ a/scripts/spelling.txt
@@ -9,6 +9,7 @@
 #
 abandonning||abandoning
 abigious||ambiguous
+abitrary||arbitrary
 abitrate||arbitrate
 abnornally||abnormally
 abnrormal||abnormal
_
