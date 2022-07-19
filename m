Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B845C43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 22:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiGSW5o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238289AbiGSW5n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 18:57:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD496624B8
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 15:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DB4860B9B
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 22:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A394CC341C6;
        Tue, 19 Jul 2022 22:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658271461;
        bh=kXCXVs8L/IKATTNPE+rgHjCQZTmiVO0aH77OSLDDlsg=;
        h=Date:To:From:Subject:From;
        b=cDO02y1blxq38KjAa7hD6uAcdiSac315hVKDu4TR2RUn3hfUm1+ylj1gSYx8MDCi5
         wYlJ+SZuBI2LlxnJElMNU2fjVJktJUeAo3VIbTgIQ2yGTyCNUKqebcA0GBxm2Tj6ww
         Idq3MjnT1yza3DNjyj3YUdHj6bYWYXKXOVBp6q5I=
Date:   Tue, 19 Jul 2022 15:57:40 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-gao-xiangs-email-addresses.patch added to mm-hotfixes-unstable branch
Message-Id: <20220719225741.A394CC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Gao Xiang's email addresses
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-gao-xiangs-email-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-gao-xiangs-email-addresses.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gao Xiang <xiang@kernel.org>
Subject: mailmap: update Gao Xiang's email addresses
Date: Tue, 19 Jul 2022 23:42:46 +0800

I've been in Alibaba Cloud for more than one year, mainly to address
cloud-native challenges (such as high-performance container images) for
open source communities.

Update my email addresses on behalf of my current employer (Alibaba Cloud)
to support all my (team) work in this area.  Also add an outdated
@redhat.com address of me.

Link: https://lkml.kernel.org/r/20220719154246.62970-1-xiang@kernel.org
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-gao-xiangs-email-addresses
+++ a/.mailmap
@@ -132,6 +132,8 @@ Frank Rowand <frowand.list@gmail.com> <f
 Frank Zago <fzago@systemfabricworks.com>
 Gao Xiang <xiang@kernel.org> <gaoxiang25@huawei.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@aol.com>
+Gao Xiang <xiang@kernel.org> <hsiangkao@linux.alibaba.com>
+Gao Xiang <xiang@kernel.org> <hsiangkao@redhat.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <gerald.schaefer@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@linux.vnet.ibm.com>
_

Patches currently in -mm which might be from xiang@kernel.org are

mailmap-update-gao-xiangs-email-addresses.patch

