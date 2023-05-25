Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215DEC77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241625AbjEYVu5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241954AbjEYVu4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:50:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480B91BD
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DA4B64B7B
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15C5C433D2;
        Thu, 25 May 2023 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051412;
        bh=rtPHTx01cwoyPusoryeXcyLSlFY7sSLtD7iFHHyjzBc=;
        h=Date:To:From:Subject:From;
        b=PPkxio9WFljzXiuGRNN88ZU0hfZiHESNiAQcGaulgW2tUZFLLN6TJGfRRwuabUZ4Y
         XhnHDIN79r3t5PfJNPVnTDTuMWNmgyl9hg2RfHnJhAIpjOBfNGsoNDMuZkwUQQxm6H
         Dt7ieNqkq8LL4ojBowKda0Od7drdajAnTrjW3ZPs=
Date:   Thu, 25 May 2023 14:50:12 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch added to mm-unstable branch
Message-Id: <20230525215012.C15C5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: fix typos and grammar errors
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: fix typos and grammar errors
Date: Thu, 25 May 2023 21:43:06 +0000

Fix a few typos and grammar erros in DAMON Maintainer Profile document.

Link: https://lkml.kernel.org/r/20230525214314.5204-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -3,7 +3,7 @@
 DAMON Maintainer Entry Profile
 ==============================
 
-The DAMON subsystem covers the files that listed in 'DATA ACCESS MONITOR'
+The DAMON subsystem covers the files that are listed in 'DATA ACCESS MONITOR'
 section of 'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
@@ -15,7 +15,7 @@ SCM Trees
 
 There are multiple Linux trees for DAMON development.  Patches under
 development or testing are queued in damon/next [2]_ by the DAMON maintainer.
-Suffieicntly reviewed patches will be queued in mm-unstable [1]_ by the memory
+Sufficiently reviewed patches will be queued in mm-unstable [1]_ by the memory
 management subsystem maintainer.  After more sufficient tests, the patches will
 be queued in mm-stable [3]_ , and finally pull-requested to the mainline by the
 memory management subsystem maintainer.
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-faq-remove-old-questions.patch
docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch
docs-mm-damon-design-add-a-section-for-overall-architecture.patch
docs-mm-damon-design-update-the-layout-based-on-the-layers.patch
docs-mm-damon-design-rewrite-configurable-layers.patch
docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch
docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch
docs-mm-damon-design-add-sections-for-advanced-features-of-damos.patch
docs-mm-damon-design-add-a-section-for-damon-core-api.patch
docs-mm-damon-design-add-a-section-for-the-modules-layer.patch

