Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F67EC10F1E
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiLPAjF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLPAjD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:39:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFCD5215B
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:39:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F6E3CE1D6D
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28AFC433EF;
        Fri, 16 Dec 2022 00:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151138;
        bh=lp32JH/kVVvNrmGC5hsX1FlOOUSZDSqI+e+m6dRoF1M=;
        h=Date:To:From:Subject:From;
        b=1VU/qjv/Y7Labq9XUZGYwnsuZT/4ry69Z5E+NQn+oscznCNjmL1WXH60J7SRfHJW7
         KOlc57h65IMu8Pkh1RDtlmjkTk/EIaq3nwoEblc8SQikQ4qX34+Dql0dVMgsQNklxP
         pdn2vt9Cmonv+LtQgjr5ikVm73ESNKGLvkmcdLA4=
Date:   Thu, 15 Dec 2022 16:38:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, joe@perches.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-update-copyright-dates-for-test-code.patch removed from -mm tree
Message-Id: <20221216003858.A28AFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: update copyright dates for test code
has been removed from the -mm tree.  Its filename was
     maple_tree-update-copyright-dates-for-test-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: update copyright dates for test code
Date: Tue, 25 Oct 2022 17:37:23 +0000

Add the span to the year of the development.

Link: https://lkml.kernel.org/r/20221025173709.2718725-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/radix-tree/maple.c~maple_tree-update-copyright-dates-for-test-code
+++ a/tools/testing/radix-tree/maple.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * maple_tree.c: Userspace shim for maple tree test-suite
- * Copyright (c) 2018 Liam R. Howlett <Liam.Howlett@Oracle.com>
+ * maple_tree.c: Userspace testing for maple tree test-suite
+ * Copyright (c) 2018-2022 Oracle Corporation
+ * Author: Liam R. Howlett <Liam.Howlett@Oracle.com>
  *
  * Any tests that require internal knowledge of the tree or threads and other
  * difficult to handle in kernel tests.
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


