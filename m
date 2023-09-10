Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5FBC71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjIJUrz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUrz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:47:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33F4188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:47:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7B3C433C8;
        Sun, 10 Sep 2023 20:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378870;
        bh=PFFHpzOrbgDvdgC9qQIxMMDCl32vj5r1KkRZY4r/awQ=;
        h=Date:To:From:Subject:From;
        b=mnh5avS30jvY9kxIocgPp2pNEIJv6ip9OB6WvafyIMqZ2DIBhV1H79avWDJpkMOsR
         pGYAuV8pIEer09ykrcKP4LYkRJMGiUGoT5g7RZrV8CkjfgHX/JMrALGstTRy1mc1z7
         L3yILsgOalOdBsZG8XgDGAmXubwz+/Mpv+vEHg6Y=
Date:   Sun, 10 Sep 2023 13:47:49 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch added to mm-unstable branch
Message-Id: <20230910204750.4F7B3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fixup missed :ref: keyword
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch

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
Subject: Docs/admin-guide/mm/damon/usage: fixup missed :ref: keyword
Date: Thu, 7 Sep 2023 02:29:19 +0000

Patch series "mm/damon: misc fixups for documents, comments and its
tracepoint".

This patchset contains miscellaneous simple fixups for documents, comments and
tracepoint of DAMON.


This patch (of 11):

A cross-link reference in DAMON usage document is missing ':ref:' Sphynx
keyword.  Fix it.

Link: https://lkml.kernel.org/r/20230907022929.91361-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230907022929.91361-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -392,7 +392,7 @@ pages of all memory cgroups except ``/ha
     echo N > 1/matching
 
 Note that ``anon`` and ``memcg`` filters are currently supported only when
-``paddr`` `implementation <sysfs_contexts>` is being used.
+``paddr`` :ref:`implementation <sysfs_contexts>` is being used.
 
 Also, memory regions that are filtered out by ``addr`` or ``target`` filters
 are not counted as the scheme has tried to those, while regions that filtered
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch

