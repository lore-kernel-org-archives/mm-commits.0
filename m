Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F917C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 18:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiJLS33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 14:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiJLS31 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 14:29:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1682E6FA07;
        Wed, 12 Oct 2022 11:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C60E3B81B99;
        Wed, 12 Oct 2022 18:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77FEFC433D7;
        Wed, 12 Oct 2022 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665599364;
        bh=U7x9QUONu3NO4ZRKzX+IH17ruMAnDe7sJ9Z4TTOpugQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uqfarTvZ+btEb74m72pSlBjvKGT5rWixplZIUa5U8AfLxTxhXh/JtQYxlotiF7jpx
         3ZwzSGY0wUaxVzET9XN+1BHEzlE4qjwmmYVDacx+rOXpTO78PKPzAb1b6sWl8Ao0/1
         kMZuKo1ROwRl4PsdkVi7AZp7suz1NrwbxL9El2iRSmC6YP85OKDPkEFLELGWf2mzeD
         kU9ljEjg7sdE1Y2XBi+LOdgqOe4shAYbsmUeVNxLCUjy4eccbuT/GmFoVasSDHaugM
         OysqIXNIKce9cP04ctMmfkw+TNeo1J8pAQBFovhQDPhsK/kWG///nFN4k2iIPD4vgu
         0fpj6nwYrButA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66089E21EC5;
        Wed, 12 Oct 2022 18:29:24 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.1-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221011191042.ff46a7531fb68d05da1d2530@linux-foundation.org>
References: <20221011191042.ff46a7531fb68d05da1d2530@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221011191042.ff46a7531fb68d05da1d2530@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-10-11
X-PR-Tracked-Commit-Id: d0d51a97063db4704a5ef6bc978dddab1636a306
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1440f576022887004f719883acb094e7e0dd4944
Message-Id: <166559936441.10775.2502105119182320202.pr-tracker-bot@kernel.org>
Date:   Wed, 12 Oct 2022 18:29:24 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Tue, 11 Oct 2022 19:10:42 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-10-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1440f576022887004f719883acb094e7e0dd4944

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
