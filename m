Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAA3C4167D
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiKWCxU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbiKWCxS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52789CF4D
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FFB1619FE
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F8EC43470;
        Wed, 23 Nov 2022 02:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171996;
        bh=IWQpxtb0qffk/o+nN2jEjq1rlIvHSZHEzjEtw/ckNvg=;
        h=Date:To:From:Subject:From;
        b=nEZBi4IkLIFUo757/laUEqlxW20/tprD16f2JMXwMVgO6pWCEOwG9Q0ob9/nzyvlj
         qh7MoBxcK03ek2nQj1BL4/9lQNINBietYDmVqsg4g0AwzWrq/fUmOmnTtKbCd3+d/H
         W6u0Aa2cPvRm+I5fVETqDNcsR3x0Aj0l91iJq74A=
Date:   Tue, 22 Nov 2022 18:53:16 -0800
To:     mm-commits@vger.kernel.org, alexhung@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-alex-hungs-email-address.patch removed from -mm tree
Message-Id: <20221123025316.B6F8EC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Alex Hung's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-alex-hungs-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Hung <alexhung@gmail.com>
Subject: mailmap: update Alex Hung's email address
Date: Sun, 13 Nov 2022 17:13:01 -0700

I am no longer at Canonical and add entry of my personal email address.

Link: https://lkml.kernel.org/r/20221114001302.671897-1-alex.hung@amd.com
Signed-off-by: Alex Hung <alexhung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-alex-hungs-email-address
+++ a/.mailmap
@@ -29,6 +29,7 @@ Alexandre Belloni <alexandre.belloni@boo
 Alexei Starovoitov <ast@kernel.org> <alexei.starovoitov@gmail.com>
 Alexei Starovoitov <ast@kernel.org> <ast@fb.com>
 Alexei Starovoitov <ast@kernel.org> <ast@plumgrid.com>
+Alex Hung <alexhung@gmail.com> <alex.hung@canonical.com>
 Alex Shi <alexs@kernel.org> <alex.shi@intel.com>
 Alex Shi <alexs@kernel.org> <alex.shi@linaro.org>
 Alex Shi <alexs@kernel.org> <alex.shi@linux.alibaba.com>
_

Patches currently in -mm which might be from alexhung@gmail.com are


