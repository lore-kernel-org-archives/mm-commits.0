Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48174C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiCYWnQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbiCYWnJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC52208C20
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D64DCCE2BA1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205AAC004DD;
        Fri, 25 Mar 2022 22:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248091;
        bh=r1YBwZZUvcSwTHOuFO4ptMWNcK6fShWAa4KJn+QGzUQ=;
        h=Date:To:From:Subject:From;
        b=l2ngJhCgUJO/U5q4EjIiYl4zWYN/24BisUKTOUsBaxOKR8BCBqtMcBjwk2yRkVNPK
         ONiYNZAZP9PvqjhZ4aX/zlauB2oqJR+pHj0U6cfXxGDL6IkJL8hLi/0TX4as4PiGk8
         JYFnxJolTByktQ0uL7+eveSwwojM9jHWFCltDMoE=
Date:   Fri, 25 Mar 2022 15:41:30 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net,
        skhan@linuxfoundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch removed from -mm tree
Message-Id: <20220325224131.205AAC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/page_owner.rst: fix unexpected indentation warns
has been removed from the -mm tree.  Its filename was
     docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <skhan@linuxfoundation.org>
Subject: Documentation/vm/page_owner.rst: fix unexpected indentation warns

Fix Unexpected indentation warns in page_owner:

Documentation/vm/page_owner.rst:92: WARNING: Unexpected indentation.
Documentation/vm/page_owner.rst:96: WARNING: Unexpected indentation.
Documentation/vm/page_owner.rst:107: WARNING: Unexpected indentation.

Link: https://lkml.kernel.org/r/20211215001929.47866-1-skhan@linuxfoundation.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/vm/page_owner.rst~docs-vm-fix-unexpected-indentation-warns-in-page_owner
+++ a/Documentation/vm/page_owner.rst
@@ -89,11 +89,11 @@ Usage
 
 	Page allocated via order XXX, ...
 	PFN XXX ...
-	 // Detailed stack
+	// Detailed stack
 
 	Page allocated via order XXX, ...
 	PFN XXX ...
-	 // Detailed stack
+	// Detailed stack
 
    The ``page_owner_sort`` tool ignores ``PFN`` rows, puts the remaining rows
    in buf, uses regexp to extract the page order value, counts the times
@@ -104,7 +104,7 @@ Usage
 
 	XXX times, XXX pages:
 	Page allocated via order XXX, ...
-	 // Detailed stack
+	// Detailed stack
 
    By default, ``page_owner_sort`` is sorted according to the times of buf.
    If you want to sort by the page nums of buf, use the ``-m`` parameter.
_

Patches currently in -mm which might be from skhan@linuxfoundation.org are


