Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA16C433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46C7C65005
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhCEBya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 20:54:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhCEBy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 20:54:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D5B064F79;
        Fri,  5 Mar 2021 01:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614909269;
        bh=UKhrS67QZ+wpF7Tg5ZLTEByl+AvbGgt6x8mTg1sEPgU=;
        h=Date:From:To:Subject:From;
        b=d8g2/Kw1dG90BXTmHPv/8XaF5cHhDbA4jPrUnjUu89M8IkpxcCgEctthx5bk4n5xE
         rNm6dXrmMnGwLe16IPu+VvqPC+XTTsdiwKJ8rNBFBXgugAVlQY7tRVJ7SjbVkXH5nF
         y00TPMr0U8xMRrf9h4Nm3cq7fIKGPo4dppCEVzLs=
Date:   Thu, 04 Mar 2021 17:54:29 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zuoqilin@yulong.com
Subject:  + scripts-spellingtxt-add-diabled-typo.patch added to -mm
 tree
Message-ID: <20210305015429.vXgq9y4mW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: Add "diabled" typo
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-diabled-typo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-diabled-typo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-diabled-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -470,6 +470,7 @@ devided||divided
 deviece||device
 devision||division
 diable||disable
+diabled||disabled
 dicline||decline
 dictionnary||dictionary
 didnt||didn't
_

Patches currently in -mm which might be from zuoqilin@yulong.com are

scripts-spellingtxt-add-diabled-typo.patch

