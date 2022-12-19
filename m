Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D5EC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 00:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiLSAwz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 18 Dec 2022 19:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLSAwy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 18 Dec 2022 19:52:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD002656C
        for <mm-commits@vger.kernel.org>; Sun, 18 Dec 2022 16:52:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54F80CE0B65
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 00:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FAFC433D2;
        Mon, 19 Dec 2022 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671411168;
        bh=YVASAdT8ersnow4rF+SxYNZNey65ldKB/dextdpYrR8=;
        h=Date:To:From:Subject:From;
        b=SVsG7vUNaJKkO+aYw0Wp9HrUev1PtPVHZBeLgn2YTGuRa7e30bnnkZUqCbM5VD8af
         G5QEx/R6c1eZBBm+xSQHS/tp9oYMPSH0hqGxZPtMK52A8LqiM7se4XeMi98Q2JbWSQ
         6ASsEf3KyX82x7ZLRBTvU9ZlnQLh4mdXCAt/HcDQ=
Date:   Sun, 18 Dec 2022 16:52:47 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        hannes@cmpxchg.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-deprecate-charge-moving-fix.patch added to mm-unstable branch
Message-Id: <20221219005248.43FAFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-deprecate-charge-moving-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-deprecate-charge-moving-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-deprecate-charge-moving-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-deprecate-charge-moving-fix
Date: Sun Dec 18 04:51:34 PM PST 2022

fix memory.rst underlining

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-memcontrol-deprecate-charge-moving-fix
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -720,7 +720,7 @@ NOTE2:
        otherwise the hard limit will take precedence.
 
 8. Move charges at task migration (DEPRECATED!)
-=================================
+===============================================
 
 THIS IS DEPRECATED!
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
error-injection-remove-ei_etype_none-fix.patch

