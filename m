Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A5EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2917610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhKKCx3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234547AbhKKCxS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ACB36103C;
        Thu, 11 Nov 2021 02:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599030;
        bh=/kCknpoCNwc9m16hH26pabjgNnYWZknd9o/CSLovJnw=;
        h=Date:From:To:Subject:From;
        b=Dj2z3ZqCV0guf5nx2m7ami/QpHzW4/SBvuHXgCmH0FdM50mSNMPQ58glbu9H2Fgbr
         Mp6ZMbRCFtrMdU8Cn6HZGn7d/wNr9AFOn145lif7IeZHYkaP2pKN37NZuTP5q06FLS
         XdoCBDcqx9p26iS8Eq+CKjvdStY8qxA6UVOFix4w=
Date:   Wed, 10 Nov 2021 18:50:30 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, peterx@redhat.com,
        sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch removed from -mm
 tree
Message-ID: <20211111025030.dVuie5X6F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: fix a wrong link
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


