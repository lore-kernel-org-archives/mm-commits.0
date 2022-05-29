Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5CCC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 29 May 2022 23:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiE2Xwn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 May 2022 19:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiE2Xwn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 May 2022 19:52:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AE85A15E
        for <mm-commits@vger.kernel.org>; Sun, 29 May 2022 16:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D00960FCA
        for <mm-commits@vger.kernel.org>; Sun, 29 May 2022 23:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73B8C385A9;
        Sun, 29 May 2022 23:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653868360;
        bh=ev9oHWMHvBvO28E6dj/KDXic0fbEaN1+YgTcanRyrfY=;
        h=Date:To:From:Subject:From;
        b=wU4z6eW82Lqaxb5PijgKUREEGK5LJkNExsfvNtvFMuUV0dhcc30JZm3NIc2bVkwVt
         ClK5zWMSECfbhlmNYiNzhsTSNLxSfkt5UyOHlH99QETy6cy/gztc7njFjR/sn4OzUd
         XsvqSNyp6N9zK1HfNqVxL9oTP64Dhk2orWFj/xoc=
Date:   Sun, 29 May 2022 16:52:40 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        jpoimboe@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-josh-poimboeufs-email.patch added to mm-hotfixes-unstable branch
Message-Id: <20220529235240.C73B8C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Josh Poimboeuf's email
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-josh-poimboeufs-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-josh-poimboeufs-email.patch

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
From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: mailmap: update Josh Poimboeuf's email
Date: Fri, 27 May 2022 13:18:52 -0700

I recently switched to my kernel.org email address.  Add aliases for my
previous Red Hat and IBM addresses.

Link: https://lkml.kernel.org/r/0519dcfbb1ee2cb82cb32b0aff61410a62949aa5.1653682698.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-josh-poimboeufs-email
+++ a/.mailmap
@@ -201,6 +201,8 @@ Jordan Crouse <jordan@cosmicpenguin.net>
 <josh@joshtriplett.org> <josht@linux.vnet.ibm.com>
 <josh@joshtriplett.org> <josht@us.ibm.com>
 <josh@joshtriplett.org> <josht@vnet.ibm.com>
+Josh Poimboeuf <jpoimboe@kernel.org> <jpoimboe@redhat.com>
+Josh Poimboeuf <jpoimboe@kernel.org> <jpoimboe@us.ibm.com>
 Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
_

Patches currently in -mm which might be from jpoimboe@kernel.org are

mailmap-update-josh-poimboeufs-email.patch

