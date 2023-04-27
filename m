Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254EDC77B61
	for <mm-commits@archiver.kernel.org>; Thu, 27 Apr 2023 20:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344026AbjD0Uqj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Apr 2023 16:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344017AbjD0Uq1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2023 16:46:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9C3E55
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 13:46:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F31D863FBF
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B32C433EF;
        Thu, 27 Apr 2023 20:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682628364;
        bh=6TJY6nCBQoIrJy0Ta2cSgv4KjrwQ9N6DZpGuG6ny9kc=;
        h=Date:To:From:Subject:From;
        b=ej97cVT2PjU0UMEzVyGoJS/NnWbtMUyDHvrC7GImmS5xmIjWBUO0oyYgH8upSoOWU
         OV0lQfA7iC6id7YRgch5vQDwc381eFpcsNH2rGPLV/QShVluaMtz75iTFPR/ItZVcL
         XjHs7RAG+vpqSWWgg9dmmnrChRg46tVzwXJZoY8U=
Date:   Thu, 27 Apr 2023 13:46:03 -0700
To:     mm-commits@vger.kernel.org, paulus@ozlabs.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-entries-for-paul-mackerras.patch removed from -mm tree
Message-Id: <20230427204604.59B32C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entries for Paul Mackerras
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-paul-mackerras.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Paul Mackerras <paulus@ozlabs.org>
Subject: mailmap: add entries for Paul Mackerras
Date: Mon, 24 Apr 2023 17:01:32 +1000

Link: https://lkml.kernel.org/r/ZEYpTAufVHTvsO1n@cleo
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-paul-mackerras
+++ a/.mailmap
@@ -370,6 +370,8 @@ Paul E. McKenney <paulmck@kernel.org> <p
 Paul E. McKenney <paulmck@kernel.org> <paulmck@linux.ibm.com>
 Paul E. McKenney <paulmck@kernel.org> <paulmck@linux.vnet.ibm.com>
 Paul E. McKenney <paulmck@kernel.org> <paulmck@us.ibm.com>
+Paul Mackerras <paulus@ozlabs.org> <paulus@samba.org>
+Paul Mackerras <paulus@ozlabs.org> <paulus@au1.ibm.com>
 Peter A Jonsson <pj@ludd.ltu.se>
 Peter Oruba <peter.oruba@amd.com>
 Peter Oruba <peter@oruba.de>
_

Patches currently in -mm which might be from paulus@ozlabs.org are


