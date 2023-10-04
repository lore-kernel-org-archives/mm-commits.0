Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DE8E7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243984AbjJDUSU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244000AbjJDUSS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AEED8
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3580C433C8;
        Wed,  4 Oct 2023 20:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450694;
        bh=Ejy7zv+3/5tQjvVYTJ10CnJPQvyd7DBR8mBX/rgdrp0=;
        h=Date:To:From:Subject:From;
        b=JySBUddHKbrrsKAXZ/UrGxA0hhz1pCKxj9k641tZYoBEaoh3f5s9hwEl/n0toTiqr
         4IaAgswcmbIp8HrQRSaLffffP6XaQcMGCNjTAeRfse0h99pOrtWDImXfSwGJSzpXAF
         3/51WiEZsCDk74/bUKgZLroecECAF7N4O5Lp6OVs=
Date:   Wed, 04 Oct 2023 13:18:12 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch removed from -mm tree
Message-Id: <20231004201813.D3580C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fixup missed :ref: keyword
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


