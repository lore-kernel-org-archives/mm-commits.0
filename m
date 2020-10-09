Return-Path: <SRS0=4AP6=DQ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94ABDC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Oct 2020 22:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52320222C3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Oct 2020 22:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602283737;
	bh=4AcXj946OamZh5pd9PHeidOj4zOJu3/8Z9TlPZnU0VM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pM33vvd4k9gzZhb5THqulfHuShJ5wSqLOevdfRj4v1+ru0e7d9hKbQTv38VqHHBnQ
	 53WOAXwgRJ+Slbk/mfyXXPc0db36jUxs3mXVtM7r8xCEmH3AKkjplKs4864TMErVvq
	 9pdoSgFQFNgDHidCkWYKPbgXoFFK6udxuaxF7rLA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392011AbgJIWsD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Oct 2020 18:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388159AbgJIWro (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Oct 2020 18:47:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACCF62222F;
        Fri,  9 Oct 2020 22:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602283663;
        bh=4AcXj946OamZh5pd9PHeidOj4zOJu3/8Z9TlPZnU0VM=;
        h=Date:From:To:Subject:From;
        b=ZaqKmZQ8TR+c2NLg10ncBRHktXFFUyXTEmjquvmlkt23qJ1iXMAtgfo5b2T91SdS9
         6QFo8rQ2D1DmOWVTqHQoiad3L24HUIJujC3Nog6TvShq0mKkKPp5ZkadfiU2IvXbJ+
         qO3R5P44AcEXKGzH+gbAobmUY6Z9Ntd44LvYo+Yc=
Date:   Fri, 09 Oct 2020 15:47:43 -0700
From:   akpm@linux-foundation.org
To:     apw@canonical.com, colin.king@canonical.com, joe@perches.com,
        mm-commits@vger.kernel.org, naoki.hayama@lineo.co.jp
Subject:  + scripts-spellingtxt-add-arbitrary-typo.patch added to
 -mm tree
Message-ID: <20201009224743.yzgRxBssJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "arbitrary" typo
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-arbitrary-typo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-arbitrary-typo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-arbitrary-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from naoki.hayama@lineo.co.jp are

scripts-spellingtxt-add-arbitrary-typo.patch

