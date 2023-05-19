Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE786C7EE26
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 18:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjESScp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 14:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjESSco (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 14:32:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9841A5;
        Fri, 19 May 2023 11:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 825BA65A5E;
        Fri, 19 May 2023 18:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E35D5C433EF;
        Fri, 19 May 2023 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684521162;
        bh=6z6VnKDMJ9Z6QjVLBMuj7xV3WTFENjZl77zsA1rZ8Fo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gFC2Wvqh29BbEjIzwmxntQe3xXeHJ8MSTwdmjW4K47SHwk6SmoOWtRgKtCRpBb20T
         i3T+dDBlZlvh4BbOnyAzvpRzlWzo9mNh1Q2yRV/GN4K5z0p9H83kjCx62xCXsDFS0q
         qwd1+l68ZFB+4XVGpR9amsECOIQHglc9BUeWwz48+M5xFaCNo55U/OP8tTV7kJK7Vp
         iXRyKG+QmggoizfvESiT8WR1YvNvEeEWRFjdTL+2wzX8rfz6nqj9OoQfUjM0r4/zMS
         b8Tb6M4ibREPLfzUInAzq4MABBRWVc/syPOaQzzyzRYvBwBfJA/r6FxCkZ8WMN8+qB
         RNlyy+CLfNCUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0DC1C3959E;
        Fri, 19 May 2023 18:32:42 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.4-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230518155606.326cc8a860382d3a08cf5e21@linux-foundation.org>
References: <20230518155606.326cc8a860382d3a08cf5e21@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230518155606.326cc8a860382d3a08cf5e21@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-05-18-15-52
X-PR-Tracked-Commit-Id: c7394fa9aa4ccd4e477626c4f7aef0b360c92efb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f4a8871f9f347b185c44525c9bb1755951f94841
Message-Id: <168452116285.23824.2103312105983458925.pr-tracker-bot@kernel.org>
Date:   Fri, 19 May 2023 18:32:42 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Thu, 18 May 2023 15:56:06 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-05-18-15-52

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f4a8871f9f347b185c44525c9bb1755951f94841

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
