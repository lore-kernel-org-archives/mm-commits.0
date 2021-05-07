Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CFCC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D247613D6
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhEGBHP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhEGBHP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57CCF613D8;
        Fri,  7 May 2021 01:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349576;
        bh=91h3kb3vMejdM7Fq+K6borp4Az0P0EZmL3aqzEn3DTc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LsaIigZoo4rT2P86nEbsYnDXK/vCW9maZQgYv68ibE8XdzfIMbFEpa4AX+JHjXApg
         uVZ7vG/RZhQA6vHWsEm3cLaQsak4KLQz+cDUENRuNAYMJJLmOaeBBRtJB0F2uTYjPS
         8aoztKF/1GBIs3QexG+NhcNWtH0EE1zFclvu+GtE=
Date:   Thu, 06 May 2021 18:06:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zuoqilin@yulong.com
Subject:  [patch 79/91] scripts/spelling.txt: add "diabled" typo
Message-ID: <20210507010615.8OLMegsx0%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>
Subject: scripts/spelling.txt: Add "diabled" typo

Increase "diabled" spelling error check.

Link: https://lkml.kernel.org/r/20210304070106.2313-1-zuoqilin1@163.com
Signed-off-by: zuoqilin <zuoqilin@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-diabled-typo
+++ a/scripts/spelling.txt
@@ -480,6 +480,7 @@ devided||divided
 deviece||device
 devision||division
 diable||disable
+diabled||disabled
 dicline||decline
 dictionnary||dictionary
 didnt||didn't
_
