Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498B4C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3495F60F26
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhKKCva (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhKKCv3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD5A6103C;
        Thu, 11 Nov 2021 02:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598921;
        bh=slDrBnbQg9OVMMQY8EQBITBOtCB5ezsG9MhQTUV0kt8=;
        h=Date:From:To:Subject:From;
        b=cE0kUj0OdafFaLwc2Dh+A9vyP7hGYB1bUSvbn+5h7ATx7hPGKb92OwNt15X5sMX2N
         3mCqcuLUSSMsEbQfrnwmSS25hBVSGqBD1lHNx2IRHAln1uisNpBDj5y4TyH0+OxdKY
         Dd4h+6lWQ66ByCjDvFwwuGrdR/xA+CxpipmDiyT8=
Date:   Wed, 10 Nov 2021 18:48:41 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  [merged] docs-vm-damon-remove-broken-reference.patch
 removed from -mm tree
Message-ID: <20211111024841.hjJYXfaDB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs/vm/damon: remove broken reference
has been removed from the -mm tree.  Its filename was
     docs-vm-damon-remove-broken-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: docs/vm/damon: remove broken reference

Building DAMON documents warns for a reference to nonexisting doc, as
below:

    $ time make htmldocs
    [...]
    Documentation/vm/damon/index.rst:24: WARNING: toctree contains reference to nonexisting document 'vm/damon/plans'

This commit fixes the warning by removing the wrong reference.

Link: https://lkml.kernel.org/r/20210917123958.3819-4-sj@kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/damon/index.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/vm/damon/index.rst~docs-vm-damon-remove-broken-reference
+++ a/Documentation/vm/damon/index.rst
@@ -27,4 +27,3 @@ workloads and systems.
    faq
    design
    api
-   plans
_

Patches currently in -mm which might be from sjpark@amazon.de are


