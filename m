Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7456DC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbjFIXdQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjFIXcA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4817E30FE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA8CB65D05
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E3AC433D2;
        Fri,  9 Jun 2023 23:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353381;
        bh=SegKDA9sLJws+k4dUfZ++2gRJRK8B6Uqu6MisfFhxbk=;
        h=Date:To:From:Subject:From;
        b=TNP8QhyEsq65SxP/5afJwfAm9RWC56x+G8XbvRo9PuggCPWILT64niFDdxJpE3XX7
         qdezCliaBq+w96cWoQ4pDC7DPeGhOUhhdR5lLlBFIFm5F8FSHRZbhJYtr+ETohUGF0
         lDCX9BYxLI75tcBfupZh1hGx4fo69cv/HargU50Y=
Date:   Fri, 09 Jun 2023 16:29:40 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch removed from -mm tree
Message-Id: <20230609232941.41E3AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: fix typos and grammar errors
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


