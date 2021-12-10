Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4946C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344728AbhLJWtz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344718AbhLJWtz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:49:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FD9C061746
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 14:46:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3EBBFCE2B7D
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A85C00446;
        Fri, 10 Dec 2021 22:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176376;
        bh=3kSYkvahVge6GQYSndlU6LLbdztfAJBeUSXlxH59A0o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MBN/J0mjPT8YFFj99Cgnpb0WYkkP7jSi/NFxC7hb6ozcpxNJrDKJfeqNfTxeFov2l
         L9B6LaoT+aEd6pnCp1yZUE9jx7BOL460Yi7nrBqD8ZVNNfreTG9Aw9NpOHnSIRaJ2P
         gLX4k9oXC+694mAd7ah4TwvIjZ7EE3rt1HYBypAg=
Date:   Fri, 10 Dec 2021 14:46:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guoren@linux.alibaba.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 03/21] mailmap: update email address for Guo Ren
Message-ID: <20211210224615.2wbsN0Uw_%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>
Subject: mailmap: update email address for Guo Ren

The ren_guo@c-sky.com would be deprecated and use guoren@kernel.org as the
main email address.

Link: https://lkml.kernel.org/r/20211123022741.545541-1-guoren@kernel.org
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-email-address-for-guo-ren
+++ a/.mailmap
@@ -126,6 +126,8 @@ Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
 Greg Kurz <groug@kaod.org> <gkurz@linux.vnet.ibm.com>
 Gregory CLEMENT <gregory.clement@bootlin.com> <gregory.clement@free-electrons.com>
+Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
+Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
 Gustavo Padovan <padovan@profusion.mobi>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
_
