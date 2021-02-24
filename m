Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192D2C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD1564EC3
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbhBXUBa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhBXUA4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE66E64F0B;
        Wed, 24 Feb 2021 20:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196816;
        bh=AyrAnzFlz+24Nks6FyCV8kwiw//Kf6WeFWFFanccBP4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nCOyC3XVxwOuIp80Ad25iFmkolnWltKVIWa/Y8AuEH+RbzYFPMMl4AX2s67ohzZ9/
         38ickzpqcSjcZxqaGmGY8CXfi/dTZTYhGWT5eGGUb1Uh1ElNpgIK7tJSxFkx8zCCuJ
         oYJg5sQyFxX5H82NdITV7FK8+tKH3OKn1YPvR040=
Date:   Wed, 24 Feb 2021 12:00:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tangchunyou@yulong.com,
        torvalds@linux-foundation.org, zhangwen@yulong.com
Subject:  [patch 002/173] scripts/spelling.txt: increase
 error-prone spell checking
Message-ID: <20210224200015.HbMroA039%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: tangchunyou <tangchunyou@yulong.com>
Subject: scripts/spelling.txt: increase error-prone spell checking

Increase maping spelling error check.

Link: https://lkml.kernel.org/r/20210121092125.2663-1-tangchunyou@163.com
Signed-off-by: WenZhang <zhangwen@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-increase-error-prone-spell-checking
+++ a/scripts/spelling.txt
@@ -875,6 +875,7 @@ manger||manager
 manoeuvering||maneuvering
 manufaucturing||manufacturing
 mappping||mapping
+maping||mapping
 matchs||matches
 mathimatical||mathematical
 mathimatic||mathematic
_
