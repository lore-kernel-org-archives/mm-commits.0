Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F15AC7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 23:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbjFLXVp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 19:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236989AbjFLXVp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 19:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E362EBD;
        Mon, 12 Jun 2023 16:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78ED962C1C;
        Mon, 12 Jun 2023 23:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD90BC433EF;
        Mon, 12 Jun 2023 23:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686612102;
        bh=0zwLs2EizeS9sD6llGbHvZa1YRfR1qMXmbvzZNlo+WA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uTn4HVhPBat4dtW8iut63Q9eRYLaIMGv+Hu0c4bDtpjTiRXysUxr5eF5aOaGA4tYr
         1i+s98c3puIGdptb+qOn3+J7r4il+5/RL50HOGtgeysCRZEWV2N50qAqiTc9QVTLX5
         hpnKGc6BNy0q+2D8BP3IDaw7SbvlUvSZYclYcE/bHjDpCq/xnGsLFPdr10PMeK8xNl
         d/CP0M+fS8G3VNztLfyvZEwROqqCNhIrtheGZhbICdY4l2RP0K1vv0pmY1831zt74J
         FJaQHwNYFfIpU1a3xgQLxsryHiQXRdYGjX7FVSqoCHPBWreN1wLJQu5+QJyS5h1YWy
         zJz4QqHcEssEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBB26E1CF31;
        Mon, 12 Jun 2023 23:21:42 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.4-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230612122712.f495e24b80f88f58557ea470@linux-foundation.org>
References: <20230612122712.f495e24b80f88f58557ea470@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230612122712.f495e24b80f88f58557ea470@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-06-12-12-22
X-PR-Tracked-Commit-Id: 0bdf0efa180a9cb1361cbded4e2260a49306ac89
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fb054096aea0576f0c0a61c598e5e9676443ee86
Message-Id: <168661210282.25158.1059860098087339058.pr-tracker-bot@kernel.org>
Date:   Mon, 12 Jun 2023 23:21:42 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Mon, 12 Jun 2023 12:27:12 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-06-12-12-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fb054096aea0576f0c0a61c598e5e9676443ee86

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
