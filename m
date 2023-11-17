Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018DDC54FB9
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 22:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346294AbjKQWaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 17:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346312AbjKQWaL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 17:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB8119A0;
        Fri, 17 Nov 2023 14:30:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCC04C433C9;
        Fri, 17 Nov 2023 22:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700260200;
        bh=W3POoEqWruz4t3RlcQpQsz8k5ZJCPvfD3+dkOL94Zeg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VMMD74HxJx7ukoRSXz7fXxE/2IzCR+shkBgGsddpyrxW41pSbCSPuaeG3VbIt347h
         34aBWtHVhg7l8Vv2SU6kw+EdycL1W9tNUgFmY5vemV+S+PrGNIA8IjNcCpq8DUUBu5
         ccIeZVxRr3AFWj4ruX5GoKYbO/56URGie54VN2O+Htgwwcu+oKt9V6mLTrQ7MEtKeQ
         4Vlh/AKCvd0e6IlCftoEfJWTD1PwG8vbiIHhrqYYy8xA36rOFGIbF/BtgDSewR0t/e
         uIEla6ZQLSBxCbFpkCsg0Q/p9EBjsBXKLqMdx4mTLGM4/vYfMGs/70Lhoog4KY1Epz
         rhcdIBvA1Q2mQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B74EBC4316B;
        Fri, 17 Nov 2023 22:30:00 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.7-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20231117140848.02adcf56c301bb3ab85ae75a@linux-foundation.org>
References: <20231117140848.02adcf56c301bb3ab85ae75a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231117140848.02adcf56c301bb3ab85ae75a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-11-17-14-04
X-PR-Tracked-Commit-Id: afccb0804fc74ac2f6737af6a139632606cb461d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 12ee72fe01e45a9586b9d130c5501763818c8efc
Message-Id: <170026020074.3356.3062483078962425112.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Nov 2023 22:30:00 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Fri, 17 Nov 2023 14:08:48 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-11-17-14-04

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/12ee72fe01e45a9586b9d130c5501763818c8efc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
