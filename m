Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E045C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 19:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiJUTnk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 15:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiJUTnj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 15:43:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF5127FA9E;
        Fri, 21 Oct 2022 12:43:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9F7BCE2B52;
        Fri, 21 Oct 2022 19:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2D6AC433D6;
        Fri, 21 Oct 2022 19:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666381415;
        bh=gqp6L4/Mq5jHlUno38xGsSxjQNVwrlKhXHLTaJXoVV4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TrnaNDCaAXv5wsN7RPol4X5Rh3RCLFIy4eMBiUvAqhL5RCQwzwagYYXUtJU6JeenQ
         58Yokp+oLR1pF/Yj6T8q7mgt+ZFLkAOah3TB+UHkXDuRrMON7n6t/9GT8Us4bRQtMi
         5pOkxLHBXqwNFGY3oe+v0DYXMOfDZf1Xt7znTtg6WaBqQgdaXiUJ9YJi39C05caUok
         i+hl0tfhbwRpz/OdBYyCMPWG5W/dwM/fE5ys3KFCQrlfPWn4gjNut16avUaJfOWlFj
         ThqigjGkRtWi29qyJw6S3RpuK4Cj9sJBY+vloR5bZWw3TPeQP+pzH/FteA5UWFGp5S
         OvFgmIrmRYG8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE66DE270E0;
        Fri, 21 Oct 2022 19:43:34 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.1-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221020213327.2c284af5925b6a8ed915fe9e@linux-foundation.org>
References: <20221020213327.2c284af5925b6a8ed915fe9e@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221020213327.2c284af5925b6a8ed915fe9e@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-10-20
X-PR-Tracked-Commit-Id: 97061d441110528dc02972818f2f1dad485107f9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 440b7895c990a63869a9d55e5c2502dd501a124e
Message-Id: <166638141489.20847.16817656420028619926.pr-tracker-bot@kernel.org>
Date:   Fri, 21 Oct 2022 19:43:34 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Thu, 20 Oct 2022 21:33:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-10-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/440b7895c990a63869a9d55e5c2502dd501a124e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
