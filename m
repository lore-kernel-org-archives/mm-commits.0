Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69BFC433E3
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 23:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 878A320786
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 23:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595893653;
	bh=OLpCJiMncoysg7P5g1Tb2/8Y+cmAL/VSbCnEwrl9bL8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gexCtBdq0A89/4sP8x6PPFI01Fwhwb/mMyOj8JpwZR+t5PbJjpMzCth7lBxufW7VP
	 aISWZxz6AcN0fpuiUEWqaydhHmnVmGyyRA9qZrUZroB/KejfuGVTUxj3yQLASKtx3Q
	 7edvcTs40J4N5NzlhlffUWFk02ot7BiBNh1VULhE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgG0Xrd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 19:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgG0Xrd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 19:47:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F85F2070B;
        Mon, 27 Jul 2020 23:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595893652;
        bh=OLpCJiMncoysg7P5g1Tb2/8Y+cmAL/VSbCnEwrl9bL8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cq4LzTzcOhg5ypii8ER3whQN+Wy/w8KvWExNwWn55slAXnTLZG7reXZA5zCLzpMCy
         NR693BKm7DhX/WzZVhb/Jbm0TOk1p8ePisyv7ePq+4o5Xjm/06kN1S8LVRKm9bQJxL
         ammpT1EZcalX3Yp6eEFIGUUsOVzejBQc2ij45s/M=
Date:   Mon, 27 Jul 2020 16:47:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     colin.king@canonical.com, jslaby@suse.cz,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        sj38.park@gmail.com, sjpark@amazon.de
Subject:  [obsolete]
 =?US-ASCII?Q?scripts-deprecated=5Fterms-recommend-denylist-allowlist-inst?=
 =?US-ASCII?Q?ead-of-blacklist-whitelist.patch?= removed from -mm tree
Message-ID: <20200727234732.3oHIU_bQp%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/deprecated_terms: recommend denylist/allowlist instead of blacklist/whitelist
has been removed from the -mm tree.  Its filename was
     scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: scripts/deprecated_terms: recommend denylist/allowlist instead of blacklist/whitelist

This commit recommends that patches replace 'blacklist' and 'whitelist'
with 'denylist' and 'allowlist', because the new suggestions are
incontrovertible, doesn't make people hurt, and are more self-explanatory.

Link: http://lkml.kernel.org/r/20200611062550.20113-3-sjpark@amazon.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/deprecated_terms.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/deprecated_terms.txt~scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist
+++ a/scripts/deprecated_terms.txt
@@ -3,3 +3,5 @@
 # The format of each line is:
 # deprecated||suggested
 #
+blacklist||denylist
+whitelist||allowlist
_

Patches currently in -mm which might be from sjpark@amazon.de are

scripts-deprecated_terms-sync-with-inclusive-terms.patch

