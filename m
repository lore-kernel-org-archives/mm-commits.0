Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE62C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 21:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbiD0WAm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbiD0WAl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 18:00:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B57D25C7
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 14:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6B13B82AE6
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 21:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7A9C385AA;
        Wed, 27 Apr 2022 21:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651096646;
        bh=ssxGU1XPgkzHb3RtPMpIGTpM7MwQiCkmWe32S0DnWRE=;
        h=Date:To:From:Subject:From;
        b=hnCPtHel0sCKn6mNocrc/5EUTd0oM76sL2FLDWuQBayiFLLPBet/3ISwCNjbJGE22
         zrOChfIjQJB83+x2DrTagHKqTwyfbZwIsC1wftnA6v1Z8/uDAwOlFYH50P6UBBcY6C
         W0fp2I1c/QgyUQpgKzPxlPYrSqNa98jEZuBII87k=
Date:   Wed, 27 Apr 2022 14:57:25 -0700
To:     mm-commits@vger.kernel.org, seakeel@gmail.com,
        hanshenghong2019@email.szu.edu.cn, corbet@lwn.net,
        baihaowen@meizu.com, akiyks@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-vm-page_owner-use-literal-blocks-for-param-description.patch removed from -mm tree
Message-Id: <20220427215726.6B7A9C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: vm/page_owner: use literal blocks for param description
has been removed from the -mm tree.  Its filename was
     docs-vm-page_owner-use-literal-blocks-for-param-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akira Yokosawa <akiyks@gmail.com>
Subject: docs: vm/page_owner: use literal blocks for param description

Sphinx generates hard-to-read lists of parameters at the bottom of the
page.  Fix them by putting literal-block markers of "::" in front of them.

Link: https://lkml.kernel.org/r/cfd3bcc0-b51d-0c68-c065-ca1c4c202447@gmail.com
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Fixes: 57f2b54a9379 ("Documentation/vm/page_owner.rst: update the documentation")
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alex Shi <seakeel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~docs-vm-page_owner-use-literal-blocks-for-param-description
+++ a/Documentation/vm/page_owner.rst
@@ -110,7 +110,7 @@ Usage
    If you want to sort by the page nums of buf, use the ``-m`` parameter.
    The detailed parameters are:
 
-   fundamental function:
+   fundamental function::
 
 	Sort:
 		-a		Sort by memory allocation time.
@@ -122,7 +122,7 @@ Usage
 		-s		Sort by stack trace.
 		-t		Sort by times (default).
 
-   additional function:
+   additional function::
 
 	Cull:
 		--cull <rules>
@@ -153,6 +153,7 @@ Usage
 
 STANDARD FORMAT SPECIFIERS
 ==========================
+::
 
 	KEY		LONG		DESCRIPTION
 	p		pid		process ID
_

Patches currently in -mm which might be from akiyks@gmail.com are


