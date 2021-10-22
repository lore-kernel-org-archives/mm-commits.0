Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3F1C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C614A610C8
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhJVTci (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232504AbhJVTch (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 15:32:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D25CF610D0;
        Fri, 22 Oct 2021 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634931020;
        bh=kcdyfFhCcq02zrbk+dGW8CxIBRQ+reym1GGJ5Qe1Ijo=;
        h=Date:From:To:Subject:From;
        b=LpuQh6tFC/jJyd/obPtWiXn9YbFXK4NMZOa4W/BKY/sBltmGO1ALcSO3b/VuXBfFt
         PnzcH4meRcBmlKg7GL+RmnEU58nk2skF1D7lMbkrPscyzu0ihxCkCEkG2JVOGDw1xL
         czf0rt5nDXKagNGhCs91hAPZZYoBUfeXu/Mb4zdA=
Date:   Fri, 22 Oct 2021 12:30:19 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, peterx@redhat.com,
        sj@kernel.org
Subject:  + docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch
 added to -mm tree
Message-ID: <20211022193019.AnhtHEYRv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: fix a wrong link
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/start: fix a wrong link

The 'Getting Started' of DAMON is providing a link to DAMON's user
interface document while saying about its user space tool's detailed
usages.  This commit fixes the link.

Link: https://lkml.kernel.org/r/20211022090311.3856-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-fix-a-wrong-link
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -6,7 +6,9 @@ Getting Started
 
 This document briefly describes how you can use DAMON by demonstrating its
 default user space tool.  Please note that this document describes only a part
-of its features for brevity.  Please refer to :doc:`usage` for more details.
+of its features for brevity.  Please refer to the usage `doc
+<https://github.com/awslabs/damo/blob/next/USAGE.md>`_ of the tool for more
+details.
 
 
 TL; DR
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch
docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch
docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch
docs-admin-guide-mm-damon-start-simplify-the-content.patch
docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch

