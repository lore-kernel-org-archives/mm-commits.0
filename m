Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C818C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiIZV2O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiIZV2M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:28:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6CAA1D56;
        Mon, 26 Sep 2022 14:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 435FA612D3;
        Mon, 26 Sep 2022 21:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABA20C433C1;
        Mon, 26 Sep 2022 21:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664227685;
        bh=jDZqbsoZiq/I+Fhv8rIuDjBuHD5ZVMLz30M8Bshc/h4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=i0Ct9ezR9ohq0p4Mc2NsiRk7aPPIdbuJltOhAA881zPFE4R/mjI+ib1woGiTYF0zI
         heKGCESVrTKkzUiMS1aA7u4faCSbwoPJjn8kCPDe+sODC28vwizZvyTiy3RyXMUVae
         DaQfgljTtFesGb9Jo0Azr6afhje0BELeJgWo8o5hU8fANFhEmd8sSoeStRGcuwOBrK
         B+8ej+ly+K8zKwvuIcADhalsiScIeThQMgegGbu7s8q9DaVqZF1hWpAujqCpPa/k1B
         5H2+iDVyEGeI5K+XbpXnTkFwpx9BTBDqQibXzFUtcwZI8DIAsHo+UQRyLYI1DytI16
         6UACnS8RyfbJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98E52C04E59;
        Mon, 26 Sep 2022 21:28:05 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.0[-rc8]
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220926123721.2a1edc734b4fc516a9a350b8@linux-foundation.org>
References: <20220926123721.2a1edc734b4fc516a9a350b8@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20220926123721.2a1edc734b4fc516a9a350b8@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-09-26
X-PR-Tracked-Commit-Id: 59298997df89e19aad426d4ae0a7e5037074da5a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3800a713b6070d4f03fb43613a7b7d536a99b2b7
Message-Id: <166422768561.13634.7698660135812730257.pr-tracker-bot@kernel.org>
Date:   Mon, 26 Sep 2022 21:28:05 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Mon, 26 Sep 2022 12:37:21 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-09-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3800a713b6070d4f03fb43613a7b7d536a99b2b7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
