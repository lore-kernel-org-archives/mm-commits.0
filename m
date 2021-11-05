Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB029C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C164F60FBF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhKEUu5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhKEUux (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9688560FBF;
        Fri,  5 Nov 2021 20:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145293;
        bh=WYYjCw+9p5AVStszW+MdgDmdHCd9cLV2dMuI+dseqgU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yjboW2SCyIqZfWSLJaJCfXlKdpH8c5AhvRVLnqE4jhTUTwWP9RDxZ1DVjCm7OmWt8
         tfl19TuETII5gCgm6cjD+a1RkLsOJv6j4D5RoSjK08QaPVlZ3keom/U9XRYJyv4m7a
         IkSxTG/SgHLjtg1bHy6AE8eACG4R7hSK4eHyJF7U=
Date:   Fri, 05 Nov 2021 13:48:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 257/262] Docs/admin-guide/mm/damon/start: fix a
 wrong link
Message-ID: <20211105204813.v-9etVvIl%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
